@echo off
:: Weekly inkjet color cleaning print
:: Runs a PowerShell script that creates and prints a color test page

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PrintColorTest.ps1"