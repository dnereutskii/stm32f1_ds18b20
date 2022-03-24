#include "ds18b20_gpio.h"


void ds18b20_gpio_init()
{
    /*PB11 setting as output open drain*/
    RCC->APB2ENR |= RCC_APB2ENR_IOPBEN;     /*enable APB2 bus*/
    GPIOB->CRH &= ~(GPIO_CRH_MODE11_Msk|
                    GPIO_CRH_CNF11_Msk);    /*clear pin setting*/
    GPIOB->CRH |= GPIO_CRH_MODE11;          /*output mode 50MHz*/
    GPIOB->CRH |= GPIO_CRH_CNF11_0;         /*open drain*/
}