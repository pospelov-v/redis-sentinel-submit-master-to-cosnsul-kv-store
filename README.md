SCRIPTS EXECUTION<br />
sentinel notification-script and sentinel reconfig-script are used in order to configure scripts that are called to notify the system administrator or to reconfigure clients after a failover. The scripts are executed with the following rules for error handling:<br />
If script exits with "1" the execution is retried later (up to a maximum number of times currently set to 10).<br />
If script exits with "2" (or an higher value) the script execution is not retried.<br />
If script terminates because it receives a signal the behavior is the same as exit code 1.<br />
A script has a maximum running time of 60 seconds. After this limit is reached the script is terminated with a <code>SIGKILL</code> and the execution retried.<br />
<br />
NOTIFICATION SCRIPT<br />
<code>sentinel notification-script [master-name] [script-path]</code><br />
Call the specified notification script for any sentinel event that is generated in the WARNING level (for instance <code>-sdown</code>, <code>-odown</code>, and so forth). This script should notify the system administrator via email, SMS, or any other messaging system, that there is something wrong with the monitored Redis systems.<br />
The script is called with just two arguments: the first is the event type and the second the event description.<br />
The script must exist and be executable in order for sentinel to start if this option is provided.<br />
<br />
Example:<br />
<pre>
sentinel notification-script mymaster /var/redis/notify.sh
</pre>
<br />
CLIENTS RECONFIGURATION SCRIPT<br />
<code>sentinel client-reconfig-script [master-name] [script-path]</code><br />
When the master changed because of a failover a script can be called in order to perform application-specific tasks to notify the clients that the configuration has changed and the master is at a different address.<br />
The following arguments are passed to the script:<br />
<code>[master-name] [role] [state] [from-ip] [from-port] [to-ip] [to-port]</code><br />
<code>[state]</code> is currently always "failover" <code>[role]</code> is either "leader" or "observer"<br />
The arguments <code>from-ip</code>, <code>from-port</code>, <code>to-ip</code>, <code>to-port</code> are used to communicate the old address of the master and the new address of the elected slave (now a master).<br />
This script should be resistant to multiple invocations.<br />
<br />
Example:<br />
<pre>
sentinel client-reconfig-script mymaster /var/redis/reconfig.sh
</pre>

# redis-sentinel-submit-master-to-cosnsul-kv-store

This script is needed to organize High Availability according to the following scheme:
<pre>
redis-sentinel -> consul -> consul-template -> haproxy
</pre>

Install:
<pre>
systemctl stop redis-sentinel.service
</pre>

<pre>
nano /etc/redis/sentinel.conf
</pre>

<pre>
sentinel client-reconfig-script mymaster /var/lib/redis/submit-masters-to-kv-stores.sh
</pre>

<pre>
cp submit-masters-to-kv-stores.sh /var/lib/redis/
chown redis:redis /var/lib/redis/submit-masters-to-kv-stores.sh
chmod 0700 /var/lib/redis/submit-masters-to-kv-stores.sh
</pre>

<pre>
systemctl start redis-sentinel.service
</pre>

Test run:
<pre>
/var/lib/redis/submit-masters-to-kv-stores.sh mymaster leader start 10.0.0.51 6379 10.0.0.52 6379
</pre>

Check:
<pre>
consul kv get --recurse redis/master/mymaster
</pre>
