"""Python / Raspberry Pi

see https://stackoverflow.com/questions/48597852/raspberry-pi-interrupts-python-gpio-library

"""

import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(26, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(19, GPIO.IN, pull_up_down=GPIO.PUD_UP)


def interrupt_handler(channel):
    print("interrupt handler")
    if channel == 19:
        print("event on pin 19")
    elif channel == 26:
        print("event on pin 26")
    return


GPIO.add_event_detect(26, GPIO.RISING,
                      callback=interrupt_handler,
                      bouncetime=200)

GPIO.add_event_detect(19, GPIO.RISING,
                      callback=interrupt_handler,
                      bouncetime=200)

while (True):
    time.sleep(0)
