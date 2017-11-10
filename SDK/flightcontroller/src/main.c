#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xuartps.h"

#define UART_DEVICE_ID              XPAR_XUARTPS_0_DEVICE_ID
#define BUFFER_SIZE 1

unsigned int *ipEscControllerAddr1 = XPAR_ESC_CONTROLLER_0_S00_AXI_BASEADDR;	// ESC controller1 address
unsigned int *ipEscControllerAddr2 = XPAR_ESC_CONTROLLER_1_S00_AXI_BASEADDR;	// ESC controller2 address

XUartPs Uart_PS;	// Instance of the UART Device
static u8 SendBuffer[BUFFER_SIZE];	// Buffer for Transmitting Data
static u8 RecvBuffer[BUFFER_SIZE];	// Buffer for Receiving Data

int setup_uart()
{
	int status;
	XUartPs_Config *config;

	// Initialize UART: Look up the configuration, then initialize it.
	config = XUartPs_LookupConfig(UART_DEVICE_ID);
	status = XUartPs_CfgInitialize(&Uart_PS, config, config->BaseAddress);
	if(status != XST_SUCCESS)
		return XST_FAILURE;

	// Check hardware build
	if(XUartPs_SelfTest(&Uart_PS) != XST_SUCCESS)
		return XST_FAILURE;

	return XST_SUCCESS;
}


int main()
{
    init_platform();
    setup_uart();

    u8 lastReceived = 0;
    //*(ipEscControllerAddr1+0) = 0x00000000; 	// Set BLDC speed to zero
    *(ipEscControllerAddr2+0) = 0x00000000; 	// Set BLDC speed to zero
    print("ESC is ready for input.");

    while(1)
    {
    	XUartPs_Recv(&Uart_PS, &RecvBuffer[0], 1);

    	if(RecvBuffer[0] != lastReceived)
    	{
    		lastReceived = RecvBuffer[0];
    		//*(ipEscControllerAddr1+0) = RecvBuffer[0];	// Set the speed of the BLDC
    		*(ipEscControllerAddr2+0) = RecvBuffer[0];	// Set the speed of the BLDC
    		XUartPs_Send(&Uart_PS, RecvBuffer, BUFFER_SIZE);
    		while(XUartPs_IsSending(&Uart_PS));
    	}
    }

    cleanup_platform();
    return 0;
}
