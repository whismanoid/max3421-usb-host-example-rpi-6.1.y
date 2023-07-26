"""Python / Raspberry Pi

see https://stackoverflow.com/questions/48597852/raspberry-pi-interrupts-python-gpio-library

"""

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(24, GPIO.IN, pull_up_down=GPIO.PUD_UP)


def interrupt_handler(channel):
    print("interrupt handler")
    if channel == 24:
        print("event on pin GPIO24 falling edge")
        print("  MAX3421E USB Host Port reported overcurrent fault")
    return


GPIO.add_event_detect(24, GPIO.RISING,
                      callback=interrupt_handler,
                      bouncetime=200)

while (True):
    print("Lisening for overcurrent fault reports on GPIO24 falling edge...")
    print("...use CTRL+C to terminate listener...")
    time.sleep(0)
