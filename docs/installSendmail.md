

=== Install ===

<code bash>
#sudo apt install sendmail
</code>

-----

=== Configure ===

edit /etc/hostname to make sure your machine name is provided

<code bash>
#sudo vim /etc/hostname
</code>


and edit /etc/hosts :

<code bash>
#sudo vim /etc/hosts
</code>

and make it look like this (:!: order matter :!:)

<file bash>
127.0.0.1 myServer.intranet.setec-smart-efficiency.fr myServer localhost 
#127.0.1.1 myServer.intranet.setec-smart-efficiency.fr myServer
</file>

------

===How to test sendmail from the shell===

Here is a quick sendmail test to verify mail works:

<code bash>
#echo "Subject: test" | /usr/lib/sendmail -v me@domain.com Example

#echo "Subject: test" | /usr/lib/sendmail -v me@domain.com
</code>

-----

=== Fix sendmail not sending messages ===

  * edit the /etc/mail/sendmail.mc file

<code bash>
sudo vim /etc/mail/sendmail.mc

#
# Look for the  DAEMON_OPTIONS and add this line

DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=XXX.XXX.XXX.XXX')dnl

# Where XXX.XXX.XXX.XXX is the server's public address
#
# Once done, your section should look like this
#

DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=XXX.XXX.XXX.XXX')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=127.0.0.1')dnl
DAEMON_OPTIONS(`Family=inet,  Name=MSP-v4, Port=submission, M=Ea, Addr=127.0.0.1')dnl

</code>

  * restart sendmail

<code bash>
#sudo service sendmail restart
</code>
