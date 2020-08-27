# redis-sentinel-submit-master-to-cosnsul-kv-store

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
