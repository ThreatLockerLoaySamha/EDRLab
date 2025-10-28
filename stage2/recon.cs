using System;
using System.Diagnostics;
using System.Net;
using System.Management;

public class ReconTool {
    public static void Execute() {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine("\n[*] Advanced Reconnaissance Module Loaded");
        Console.ForegroundColor = ConsoleColor.Cyan;
        
        Console.WriteLine("\n[+] Network Adapter Information:");
        ManagementObjectSearcher searcher = new ManagementObjectSearcher("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True");
        foreach (ManagementObject obj in searcher.Get()) {
            Console.WriteLine("    Adapter: " + obj["Description"]);
            string[] addresses = (string[])obj["IPAddress"];
            if (addresses != null) {
                foreach (string addr in addresses) {
                    Console.WriteLine("    IP: " + addr);
                }
            }
        }
        
        Console.WriteLine("\n[+] Installed Software (Top 10):");
        ManagementObjectSearcher software = new ManagementObjectSearcher("SELECT * FROM Win32_Product");
        int count = 0;
        foreach (ManagementObject obj in software.Get()) {
            if (count++ < 10) {
                Console.WriteLine("    - " + obj["Name"]);
            }
        }
        
        Console.WriteLine("\n[+] Running Processes with Network Connections:");
        Process[] processes = Process.GetProcesses();
        foreach (Process proc in processes) {
            try {
                if (proc.Threads.Count > 10) {
                    Console.WriteLine("    [PID:" + proc.Id + "] " + proc.ProcessName);
                }
            } catch { }
        }
        
        Console.ForegroundColor = ConsoleColor.Yellow;
        Console.WriteLine("\n[*] Reconnaissance complete - Data ready for exfiltration");
        Console.ResetColor();
    }
}
