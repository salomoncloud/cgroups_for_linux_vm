# cgroups_for_linux_vm
By leveraging cgroups, you gain granular control over resource allocation and usage in your Linux-based client environments. This leads to improved system stability, better performance isolation among clients, and a more secure, predictable operating environment. Whether you’re dealing with traditional VMs or containerized workloads, cgroups are a powerful tool in a cloud administrator's toolkit to manage multi-tenant resource consumption effectively.
-------

How this script works:

PRIVELEGE CHECK - 

The script first checks if it’s running as root because modifying cgroup settings requires elevated privileges.

DIRECTORY SETUP - 

It sets up variables for the base cgroup mount point (usually /sys/fs/cgroup) and defines two subdirectories—one for CPU settings and one for memory settings. It then creates these directories if they don’t exist.

SET LIMITS - 

For CPU: It writes 512 to the cpu.shares file. (The default is often 1024; a lower value means this group gets a lower share of the CPU time.)

For Memory: It writes the desired memory limit (256 MB in bytes) to the memory.limit_in_bytes file.

RUNNING PROCESS - 

The script then starts a process (using the stress command as an example) in the background and captures its PID.

ASSIGNING PROCESS TO CGROUPS - 

The process’s PID is written into the tasks files for both the CPU and memory cgroups. This action “moves” the process into those cgroups, so its resource consumption is now governed by the limits you set.

-------
Using scripts like this can be very helpful in managing and isolating resources for processes or VMs, ensuring that client environments remain stable and that no single process can monopolize system resources.
