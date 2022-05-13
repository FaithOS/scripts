#!/bin/bash
CHECK_OS(){

awk -F= '/^NAME/{print $2}' /etc/os-release
}
