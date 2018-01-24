﻿<#
.Synopsis
    Quick PortScan / EgressBuster

    PortScan / EgressBuster 2017
    Rob Maslen @rbmaslen 

.DESCRIPTION
	PS C:\> Usage: PortScan -IPaddress <IPaddress> -Ports <Ports> -maxQueriesPS <maxQueriesPS> -Delay <Delay>
.EXAMPLE
    PS C:\> PortScan -IPaddress 127.0.0.1 -Ports 1-65535 -maxQueriesPS 10000
.EXAMPLE
    PS C:\> PortScan -IPaddress 192.168.1.0/24 -Ports 1-65535 -maxQueriesPS 10000
.EXAMPLE
    PS C:\> PortScan -IPaddress 192.168.1.1-50 -Ports "80,443,55" -maxQueriesPS 10000
.EXAMPLE
    PS C:\> PortScan -IPaddress 192.168.1.1-50 -Ports "80,443,55" -maxQueriesPS 1 -Delay 1
#>
$pscanloaded = $null
function PortScan {
param(
[Parameter(Mandatory=$true)][string]$IPaddress, 
[Parameter(Mandatory=$false)][string]$Ports="1-1000",
[Parameter(Mandatory=$false)][string]$maxQueriesPS=1000,
[Parameter(Mandatory=$false)][int]$Delay=0
)

    $Delay = $Delay *1000
    if ($pscanloaded -ne "TRUE") {
        $script:pscanloaded = "TRUE"
        echo "[+] Loading Assembly"
        $ps = "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EgQocQAACiwSCReaEgUocQAACiwGEQQRBTERctwGAHAIKBMAAApzKwAACnoRBBMGKyQCexcAAAQRBtFvcgAACi0OAnsXAAAEEQbRb3MAAAoRBhdYEwYRBhEFMdYrSHLcBgBwCCgTAAAKcysAAAp6CBIHKHEAAAotEXIiBwBwCCgTAAAKcysAAAp6AnsXAAAEEQdvcgAACi0NAnsXAAAEEQdvcwAACgcXWAsHBo5pPx7///8CexcAAARvdAAACgICexcAAARvdQAACgIoQAAABm8dAAAGb3YAAApafR4AAAQqZgIoNAAABm8ZAAAKJgJ8HwAABCh3AAAKJioAEzABAEEAAAAAAAAAAig0AAAGb3gAAAomAnwfAAAEKHkAAAomAnweAAAEKHkAAAomAnsfAAAELRQCex4AAAQtDAIoMgAABm8YAAAKJioeAnsiAAAEKiICA30iAAAEKhp+IwAABCoeAoAjAAAEKh4CeyQAAAQqIgIDfSQAAAQqHgJ7JQAABCoiAgN9JQAABCoeAnsmAAAEKiICA30mAAAEKjIWc2sAAAooUQAABioAAAAbMAIASgAAAAkAABECKFQAAAYWMUAoUAAABi0oAnsnAAAECgYoUwAACihQAAAGLQsWc2sAAAooUQAABt4HBihUAAAK3ChQAAAGAihUAAAGbzQAAAomKgAAARAAAAIAHQAUMQAHAAAAAEoCc0MAAAp9JwAABAIoQwAACio6AihDAAAKAgN9KAAABCoyAnsoAAAEc18AAAYqHgIoXAAABioeAihdAAAGKgATMAIAVwAAAA0AABECKEMAAAoCA30pAAAEAygRAAAGCgMoEgAABgsGb0UAAAosCQIGKGEAAAYrDwdvRQAACiwHAgcoYAAABgZvRQAACi0TB29FAAAKLQtyTgcAcHMrAAAKeioAEzAEAJsAAAAOAAARA296AAAKcr4HAHBvewAACm98AAAKKH0AAAoKA296AAAKcsQHAHBvewAACm98AAAKKH4AAAoLA296AAAKcs4HAHBvewAACm98AAAKKH4AAAoMBwgxC3LUBwBwcysAAAp6CCD+AAAAMQtyKggAcHMrAAAKegZvfwAACiUogAAAChYogQAACg0CCX0qAAAEAgkIB1lYF1h9KwAABCoAEzADALIAAAAPAAARA296AAAKcr4HAHBvewAACm98AAAKKH0A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MwAVAAIANAAXAAEANQAXAAIANgAZAAEANwAZAAIAOAAbAAEAOQAbAAIAOgAdAAEAOwAdAAIAPAAfAAEAPQAfAAIAPgAhAAEAPwAhAAIAQAAjAAEAQQAlAAIAQwAnAAIARQApAAEARAApAAIARgArAAEARwArAAIASAAtAAEASQAtAAIATgAvAAEATwAvAAIAUAAxAAEAUQAxAAIAUgAzAAEAUwAzAAIAVAA1AAEAVQA1AAIAVgA3AAEAVwA3AAIAYwA5AAIAZgA7AAIAZwA9AAoAvAAfAAsAzgAhACAAKwCPAKoAwQDZAOgACwEUAR0BJgEsAesBAgKZAgSAAAABAAAAAAAAAAAAAAAAAHwHAAACAAAAAAAAAAAAAADOAqoAAAAAAAIAAAAAAAAAAAAAAM4CJAgAAAAACgADAAsAAwAAAAAAAE51bGxhYmxlYDEASUVudW1lcmFibGVgMQBJRW51bWVyYXRvcmAxAExpc3RgMQBHZXRFbnVtZXJhdG9yMQBnZXRfQ3VycmVudDEAVG9VSW50MzIARGljdGlvbmFyeWAyAFVJbnQxNgA8TW9kdWxlPgBnZXRfQUZfVFlQRQBzZXRfQUZfVFlQRQBJc0lQAGdldF9DdXJyZW50SVAAc2V0X0N1cnJlbnRJUABtc2NvcmxpYgBfc2IAU3lzdGVtLkNvbGxlY3Rpb25zLkdlbmVyaWMAQWRkAEludGVybG9ja2VkAGdldF9Db25uZWN0ZWQAT25TY2FuQ29tcGxldGVkADxBRl9UWVBFPmtfX0JhY2tpbmdGaWVsZAA8Q3VycmVudElQPmtfX0JhY2tpbmdGaWVsZAA8U2NhblN0YXRlPmtfX0JhY2tpbmdGaWVsZAA8VG90YWxTY2FubmluZz5rX19CYWNraW5nRmllbGQAPFRhcmdldHM+a19fQmFja2luZ0ZpZWxkADxPcGVuUG9ydHM+a19fQmFja2luZ0ZpZWxkADxWaXN1YWxSZXN1bHRTZXQ+a19fQmFja2luZ0ZpZWxkADxUYXJnZXQ+a19fQmFja2luZ0ZpZWxkADxTb2NrZXQ+a19fQmFja2luZ0ZpZWxkADxTY2FuRW5kRXZlbnQ+a19fQmFja2luZ0ZpZWxkADxTY2FuRGVsYXlFdmVudD5rX19CYWNraW5nRmllbGQAPEVuZFBvcnQ+a19fQmFja2luZ0ZpZWxkADxDdXJyZW50UG9ydD5rX19CYWNraW5nRmllbGQAPFN0YXJ0UG9ydD5rX19CYWNraW5nRmllbGQAPF9Qb3J0U3ludGF4PmtfX0JhY2tpbmdGaWVsZAA8RGVsYXk+a19fQmFja2luZ0ZpZWxkAEFwcGVuZABnZXRfTWVzc2FnZQBJc0lQUmFuZ2UAUHJvY2Vzc0lQUmFuZ2UASXBSYW5nZQBQcm9jZXNzQ2lkclJhbmdlAGdldF9UYXJnZXRSYW5nZQBzZXRfVGFyZ2V0UmFuZ2UASW52b2tlAElFbnVtZXJhYmxlAElEaXNwb3NhYmxlAHNldF9DdXJzb3JWaXNpYmxlAEV2ZW50V2FpdEhhbmRsZQBDb25zb2xlAHBvc2l0aW9uTmFtZQBDaGVja0hvc3ROYW1lAG5hbWUARGF0ZVRpbWUAV2FpdE9uZQBBcHBlbmRMaW5lAFdyaXRlTGluZQBVcmlIb3N0TmFtZVR5cGUAUHJvdG9jb2xUeXBlAFNvY2tldFR5cGUAU2VtYXBob3JlAENhcHR1cmUAUmVsZWFzZQBDbG9zZQBEaXNwb3NlAFRyeVBhcnNlAFJldmVyc2UAZ2V0X0FzeW5jU3RhdGUAVENQU2NhblN0YXRlAGdldF9TY2FuU3RhdGUAc2V0X1NjYW5TdGF0ZQBzY2FuU3RhdGUAc2Nhbm5lclN0YXRlAF9zdGF0ZQBXcml0ZQBDb21waWxlckdlbmVyYXRlZEF0dHJpYnV0ZQBHdWlkQXR0cmlidXRlAERlYnVnZ2FibGVBdHRyaWJ1dGUAQ29tVmlzaWJsZUF0dHJpYnV0ZQBBc3NlbWJseVRpdGxlQXR0cmlidXRlAEFzc2VtYmx5VHJhZGVtYXJrQXR0cmlidXRlAEFzc2VtYmx5RmlsZVZlcnNpb25BdHRyaWJ1dGUAQXNzZW1ibHlDb25maWd1cmF0aW9uQXR0cmlidXRlAEFzc2VtYmx5RGVzY3JpcHRpb25BdHRyaWJ1dGUARGVmYXVsdE1lbWJlckF0dHJpYnV0ZQBDb21waWxhdGlvblJlbGF4YXRpb25zQXR0cmlidXRlAEFzc2VtYmx5UHJvZHVjdEF0dHJpYnV0ZQBBc3NlbWJseUNvcHlyaWdodEF0dHJpYnV0ZQBBc3NlbWJseUNvbXBhbnlBdHRyaWJ1dGUAUnVudGltZUNvbXBhdGliaWxpdHlBdHRyaWJ1dGUAZ2V0X1ZhbHVlAGdldF9IYXNWYWx1ZQB2YWx1ZQBTeXN0ZW0uVGhyZWFkaW5nAFBlcmZvcm1UQ1BDb25uZWN0U2Nhbk5vbkJsb2NraW5nAGNhbmNlbEFsbFJlbWFpbmluZwBnZXRfUG9ydHNSZW1haW5pbmcAZ2V0X1RvdGFsU2Nhbm5pbmcAc2V0X1RvdGFsU2Nhbm5pbmcAQ3VycmVudFNjYW5uaW5nAFRvTG9uZ1RpbWVTdHJpbmcAVG9TdHJpbmcAVUludFRvSXBTdHJpbmcARGVjcmVtZW50V2FpdGluZwBJbmNyZW1lbnRXYWl0aW5nAHJhbmdlTWNoAGNpZHJtY2gASXBSYW5nZU1hdGNoAElwQ2lkck1hdGNoAGdldF9MZW5ndGgAc2V0X0xlbmd0aABtYXBOYW1lVG9QcmV2V3JpdGVMZW5ndGgAVXJpAEFzeW5jQ2FsbGJhY2sAV2FpdENhbGxiYWNrAEhvc3RUb05ldHdvcmsAdmVydGljYWwAX2ludGVybmFsAENhbmNlbEFsbABQb3J0U2Nhbm5lci1EbGwAUG9ydFNjYW5uZXItRGxsLmRsbABUaHJlYWRQb29sAFdyaXRlTGluZUltcGwAV3JpdGVJbXBsAFdyaXRlQXRSZWNQb3NpdGlvbkltcGwAUmVjb3JkUG9zaXRpb25JbXBsAFByb2Nlc3NUYXJnZXRzSW1wbABnZXRfSXRlbQBzZXRfSXRlbQBRdWV1ZVVzZXJXb3JrSXRlbQBTeXN0ZW0AVHJpbQBEb1NjYW4AZ2V0X1BvcnRzVG9TY2FuAHNldF9Qb3J0c1RvU2NhbgBQZXJmb3JtVENQQ29ubmVjdFNjYW4AU3RhcnRTY2FuAFN5c3RlbS5SZWZsZWN0aW9uAEdyb3VwQ29sbGVjdGlvbgBLZXlDb2xsZWN0aW9uAFdyaXRlQXRSZWNQb3NpdGlvbgBSZWNvcmRQb3NpdGlvbgBtYXBOYW1lVG9DdXJzb3JQb3NpdGlvbgBJbnZhbGlkT3BlcmF0aW9uRXhjZXB0aW9uAFBvcnRTY2FubmVyX0RsbC5Db21tb24AUG9ydFNjYW5uZXIuQ29tbW9uAGlwAGdldF9DdXJzb3JUb3AAc2V0X0N1cnNvclRvcABHcm91cABDaGFyAF9oaUFkZHIAX2xvQWRkcgBJc0lQQ2lkcgBfaXBfY2lkcgBfaXBjaWRyAFN0cmluZ0J1aWxkZXIAX2xvY2tlcgBFdmVudEhhbmRsZXIAUG9ydFNjYW5uZXIuQ29uc29sZUNvbnRyb2xsZXIAUG9ydFNjYW5uZXJfRGxsLlNjYW5uZXIAVENQQ29ubmVjdFNjYW5uZXIAQ29uc29sZVVwZGF0ZXIARW50ZXIAQml0Q29udmVydGVyAElFbnVtZXJhdG9yAGdldF9JUEVudW1lcmF0b3IASVBSYW5nZUVudW1lcmF0b3IAU3lzdGVtLkNvbGxlY3Rpb25zLklFbnVtZXJhYmxlLkdldEVudW1lcmF0b3IALmN0b3IALmNjdG9yAE1vbml0b3IAU3lzdGVtLkRpYWdub3N0aWNzAFNldE1heFRocmVhZHMAU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzAFN5c3RlbS5SdW50aW1lLkNvbXBpbGVyU2VydmljZXMARGVidWdnaW5nTW9kZXMAR2V0QWRkcmVzc0J5dGVzAEdldEJ5dGVzAEV2ZW50QXJncwBJUHY0VG9vbHMARG5zAENvbnRhaW5zAFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucwBTeXN0ZW0uQ29sbGVjdGlvbnMAcmV0aHJvd0V4Y2VwdGlvbnMAZ2V0X0dyb3VwcwBQb3J0U2Nhbm5lcl9EbGwuSGVscGVycwBnZXRfU3VjY2VzcwBJUEFkZHJlc3MAYWRkcmVzcwBnZXRfVGFyZ2V0cwBzZXRfVGFyZ2V0cwBnZXRfVENQU2NhblRhcmdldHMAUHJvY2Vzc1RhcmdldHMAU3lzdGVtLk5ldC5Tb2NrZXRzAGdldF9SZXN1bHRzAFdyaXRlVG9SZXN1bHRzAFNldFN0YXJ0QW5kRW5kUG9ydHMAZ2V0X09wZW5Qb3J0cwBzZXRfT3BlblBvcnRzAHBvcnRzAHRhcmdldEhvc3RzAGdldF9LZXlzAElzSVBSYW5nZUZvcm1hdABPYmplY3QARW5kQ29ubmVjdABCZWdpbkNvbm5lY3QAU3lzdGVtLk5ldABnZXRfVmlzdWFsUmVzdWx0U2V0AHNldF9WaXN1YWxSZXN1bHRTZXQAZ2V0X1RhcmdldABzZXRfVGFyZ2V0AFRDUFNjYW5TdGF0ZVRhcmdldAB0YXJnZXQAZ2V0X1NvY2tldABzZXRfU29ja2V0AFRDUFNjYW5TdGF0ZVNvY2tldABSZXNldABnZXRfQ3Vyc29yTGVmdABzZXRfQ3Vyc29yTGVmdABTcGxpdABJbml0AEV4aXQAR2V0VmFsdWVPckRlZmF1bHQASUFzeW5jUmVzdWx0AERlY3JlbWVudABJbmNyZW1lbnQAU3lzdGVtLkNvbGxlY3Rpb25zLklFbnVtZXJhdG9yLkN1cnJlbnQAU3lzdGVtLkNvbGxlY3Rpb25zLklFbnVtZXJhdG9yLmdldF9DdXJyZW50AF9jdXJyZW50AE1heENvbmN1cnJlbnQAbWF4Q29uY3VycmVudABnZXRfU2NhbkVuZEV2ZW50AHNldF9TY2FuRW5kRXZlbnQATWFudWFsUmVzZXRFdmVudABBdXRvUmVzZXRFdmVudABnZXRfU2NhbkRlbGF5RXZlbnQAc2V0X1NjYW5EZWxheUV2ZW50AElQRW5kUG9pbnQAZ2V0X0NvdW50AFNjYW5JUFBvcnQAZ2V0X0VuZFBvcnQAc2V0X0VuZFBvcnQAZ2V0X0N1cnJlbnRQb3J0AHNldF9DdXJyZW50UG9ydABnZXRfU3RhcnRQb3J0AHNldF9TdGFydFBvcnQAU29ydABnZXRfQWRkcmVzc0xpc3QAdGFyZ2V0SG9zdABob3N0AE1vdmVOZXh0AFN5c3RlbS5UZXh0AHRleHQAZ2V0X05vdwBnZXRfX1BvcnRTeW50YXgAc2V0X19Qb3J0U3ludGF4AF9pcFJhbmdlUmVnZXgAX2lwUmVnZXgAX2lwQ2lkclJlZ2V4AGdldF9EZWxheQBzZXRfRGVsYXkAVHJpZ2dlckRlbGF5AGRlbGF5AEFycmF5AHJlc3VsdHNSZWFkeQBDb250YWluc0tleQBBZGRyZXNzRmFtaWx5AElQSG9zdEVudHJ5AEdldEhvc3RFbnRyeQBJc051bGxPckVtcHR5AAAAK1sAWABdACAARQByAHIAbwByACAAbwBjAGMAdQByAGUAZAAgAHsAMAB9AAApWwBYAF0AIABDAEEATgBDAEUATABMAEUARAAgAEEAVAAgAHsAMAB9AABZWwAtAF0AIABTAGMAYQBuAG4AaQBuAGcAOgAgAHsAMAB9ACAAUABvAHIAdABzADoAIAB7ADEAfQAgAHcAaQB0AGgAIABkAGUAbABhAHkAIAB7ADIAfQBzAAErWwAtAF0AIABDAHUAcgByAGUAbgB0ACAASQBQAC8AUABvAHIAdAA6ACAAARdDAHUAcgByAGUAbgB0AFAAbwByAHQAAAEAK1sALQBdACAAUABvAHIAdABzACAAUgBlAG0AYQBpAG4AaQBuAGcAOgAgAAETUgBlAG0AYQBpAG4AaQBuAGcAAAd7ADAAfQAAJ1sALQBdACAAUwB0AGEAcgB0ACAAdABpAG0AZQA6ACAAewAwAH0AASNbACsAXQAgAEUAbgBkACAAdABpAG0AZQA6ACAAewAwAH0AABtbACsAXQAgAFIAZQBzAHUAbAB0AHMAOgAgAAAPUgBlAHMAdQBsAHQAcwAACVsASQBQAF0AABdQAE8AUgBUAAkAUwBUAEEAVABVAFMAAAtbAHsAMAB9AF0AABl7ADAAfQAvAHQAYwBwAAkATwBQAEUATgAALVsAKwBdACAAUgBlAHMAdQBsAHQAcwA6ACAATgBvAG4AZQAgAG8AcABlAG4AAEdbAFgAXQAgAFMAdABhAHIAdABTAGMAYQBuADoAIABUAEMAUABTAGMAYQBuAFMAdABhAHQAZQAgAGkAcwAgAG4AdQBsAGwAAA97ADAAfQA6AHsAMQB9AABLWwBYAF0AIABFAG4AZABDAG8AbgBuAGUAYwB0ADoAIABzAGMAYQBuAFMAdABhAHQAZQBTAG8AYwBrACAAaQBzACAAbgB1AGwAbAAAK1sAKwBdACAAUABvAHIAdAAgAE8AcABlAG4AIAB7ADAAfQA6AHsAMQB9AACBIV4AKAA/ADwAaQBwAD4AKAAoAFsAMAAtADkAXQB8AFsAMQAtADkAXQBbADAALQA5AF0AfAAxAFsAMAAtADkAXQB7ADIAfQB8ADIAWwAwAC0ANABdAFsAMAAtADkAXQB8ADIANQBbADAALQA1AF0AKQBcAC4AKQB7ADMAfQAoAFsAMAAtADkAXQB8AFsAMQAtADkAXQBbADAALQA5AF0AfAAxAFsAMAAtADkAXQB7ADIAfQB8ADIAWwAwAC0ANABdAFsAMAAtADkAXQB8ADIANQBbADAALQA1AF0AKQApACgAXAAvACgAPwA8AGMAaQBkAHIAPgAoAFwAZAB8AFsAMQAtADIAXQBcAGQAfAAzAFsAMAAtADIAXQApACkAKQAkAAGA014AKAAoAFsAMAAtADkAXQB8AFsAMQAtADkAXQBbADAALQA5AF0AfAAxAFsAMAAtADkAXQB7ADIAfQB8ADIAWwAwAC0ANABdAFsAMAAtADkAXQB8ADIANQBbADAALQA1AF0AKQBcAC4AKQB7ADMAfQAoAFsAMAAtADkAXQB8AFsAMQAtADkAXQBbADAALQA5AF0AfAAxAFsAMAAtADkAXQB7ADIAfQB8ADIAWwAwAC0ANABdAFsAMAAtADkAXQB8ADIANQBbADAALQA1AF0AKQAkAAGBaV4AKAA/ADwAaQBwAD4AKAAoAFsAMAAtADkAXQB8AFsAMQAtADkAXQBbADAALQA5AF0AfAAxAFsAMAAtADkAXQB7ADIAfQB8ADIAWwAwAC0ANABdAFsAMAAtADkAXQB8ADIANQBbADAALQA1AF0AKQBcAC4AKQB7ADMAfQAoAD8APABmAHIAbwBtAD4AKABbADAALQA5AF0AfABbADEALQA5AF0AWwAwAC0AOQBdAHwAMQBbADAALQA5AF0AewAyAH0AfAAyAFsAMAAtADQAXQBbADAALQA5AF0AfAAyADUAWwAwAC0ANQBdACkAKQApACgAXAAtACgAPwA8AHQAbwA+ACgAWwAwAC0AOQBdAHwAWwAxAC0AOQBdAFsAMAAtADkAXQB8ADEAWwAwAC0AOQBdAHsAMgB9AHwAMgBbADAALQA0AF0AWwAwAC0AOQBdAHwAMgA1AFsAMAAtADUAXQApACkAKQAkAAFFWwBYAF0AIABVAG4AYQBiAGwAZQAgAHQAbwAgAHIAZQBzAG8AbAB2AGUAIAB0AGgAZQAgAGgAbwBzAHQAIAB7ADAAfQAAMVsAWABdACAASQBQAEEAZABkAHIAZQBzAHMAIABpAHMAIABpAG4AdgBhAGwAaQBkAAADLQABRVAAbwByAHQAIAByAGEAbgBnAGUAIABzAHkAbgB0AGEAeAAgAHsAMAB9ACAAaQBzACAAaQBuAGMAbwByAHIAZQBjAHQAACtQAG8AcgB0ACAAewAwAH0AIABpAHMAIABuAG8AdAAgAHYAYQBsAGkAZAAAb0kAUAAgAFIAYQBuAGcAZQAgAG0AdQBzAHQAIABlAGkAdABoAGUAcgAgAGIAZQAgAGkAbgAg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"
        $dllbytes  = [System.Convert]::FromBase64String($ps)
        $assembly = [System.Reflection.Assembly]::Load($dllbytes)
    }

    $scanner = [PortScanner_Dll.Scanner.TCPConnectScanner]::PerformTCPConnectScan("$IPaddress","$Ports","$Delay","$maxQueriesPS")
    $scanner.Results

}

