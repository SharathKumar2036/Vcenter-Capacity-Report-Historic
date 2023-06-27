$servers = Get-Content C:\Users\Administrator.DEMO\Desktop\serv.txt #Create a txt file in this directory mentioning server names
$Array = @()
ForEach($Server in $Servers){ 
  #Status-Sever
IF (Test-Connection  -ComputerName $server -Quiet)  
   {                
	$os=(Get-CimInstance -ClassName Win32_OperatingSystem).Caption        
$Reachable="yes"          
#IPv4Address        
$IPv4 =(        Get-NetIPConfiguration |        Where-Object {            $_.IPv4DefaultGateway -ne $null -and            $_.NetAdapter.Status -ne "Disconnected"        }            ).IPv4Address.IPAddress        
#CPU-UTILIZATION        
$Processor= (Get-WmiObject -Class win32_processor |Measure-Object LoadPercentage -Average| Select-Object Average).Average        
$disk=Get-WmiObject -Class Win32_logicaldisk -ComputerName $Server -Filter "DriveType=3"        
$drive = (Get-WmiObject -Class Win32_logicaldisk -ComputerName $Server -Filter "DriveType=3").DeviceID        
$free=[math]::Round($disk.Freespace/1GB)        
$total=[math]::Round($disk.Size/1GB)        
$usedSpace= $total - $free        
#MEMORY UTILIZATION        
$Mem=Get-WmiObject -Class win32_operatingsystem        
$Mem2=((($Mem.TotalVisibleMemorySize-$Mem.FreePhysicalMemory)*100/$Mem.TotalVisibleMemorySize))                
} Else    
{            $os="null"            
	$Reachable="null"              
#IPv4Address           
 $IPv4 ="null"            
#CPU-UTILIZATION           
 $Processor= "null"            
#MEMORY UTILIZATION           
 $Mem="null"            
$Mem2="null"            
$drive="null"            
$total="null"            
$disk="null"           
 $usedSpace="null" 
   }    
$a=[PSCustomObject]@{        
ServerName = $server        
Reachable=$Reachable        
OperatingSystem=$os        
IPAddress=$IPv4        
Cpu_Utilization=$Processor        
Memory_Usage=$Mem2        
DiskFileSystem=$drive        
"TotalSize/UsedSize"=("$total/$usedSpace")        
}      
$Array+=$a    
if ($Processor -gt 0){        
$Array | ConvertTo-Html -Head $header -Body  "<style>table,td,th,tr{ border:1px solid #000;}</style>"$body |     
foreach {    $PSItem -replace "<td>$Processor</td>", "<td style='background-color:#FF0000'>$Processor</td>"    } | Out-File C:\Users\Administrator.DEMO\Desktop\uptime1.html                   }            

else {        $Array | Convertto-Html -Head "<style>table,td,th,tr{ border:1px solid #000;}</style>"|out-file C:\Users\Administrator.DEMO\Desktop\uptime1.html              }} 
