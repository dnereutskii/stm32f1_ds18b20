#include "ds18b20.h"
#include "ds18b20_gpio.h"
#include "ds18b20_timer.h"


void ds18b20_init()
{
    ds18b20_gpio_init();
}