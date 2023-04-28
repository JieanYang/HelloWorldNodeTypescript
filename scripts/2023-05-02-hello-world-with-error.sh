#!/bin/bash
echo "OS: Linux"

echo "This is a message before the error."
echo "Error: a custimize error message from scripts" >&2
exit 1
echo "This is a message after the error. This line will not be executed." # will never show up
