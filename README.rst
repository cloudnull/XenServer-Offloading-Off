XenServer Turning Off TCP Offloading 
####################################

If you are looking for a simple solution that can allow you to disable TCP checksumming on a XenServer Hypervisor this script is what you have been looking for. Here are the highlights of this script :

* Disables Hardware offloading using the ethtool
* Able to disable VIF Hardware offloading on a particular Instance
* Has Instance ID Checking to ensure action will be valid
* Able to disable PIF Hardware offloading on a particular Device
* Has the ability to disable ALL of the off loading for the entire Host Server
* Enforces a sanity check before performing actions on the entire Host Server

To have an idea of what this script truly does please have a look at my previous article which goes into detail on disabling TCP Offloading. You can get to the article here : `XenServer Network Tuning`_

--------

Making the script usable
========================

Once you have the application you simply have to run it. You can either make it executable or call bash before the script.

Making it executable :

.. code-block:: bash

  chmod +x offloadingoff.sh

Calling Bash

.. code-block:: bash

  bash offloadingoff.sh

--------

Running the script
==================

When you run the script you have to pass a variable or the script will refuse to run. The two possible variables are ALL or the Instance ID, which is commonly referred to as the "name-label".

An example of the Instance ID :

.. code-block:: bash

  $ offloadingoff.sh Kevins-XenServer

An Example of processing all Networking Devices on All Instances :

.. code-block:: bash

  $ offloadingoff.sh ALL

**Please Notice that "ALL" is in capital Letters.**

--------

Conclusion
==========

After running the application all TCP offloading will be turned off on what ever instance or host you run it on. It is worth mentioning that, while the parameter settings will remain, after subsequent reboots, the TCP offloading that is built into your Hardware Network Interfaces is not persistent post reboots. You will either need to modify your compiled drivers or set an ethtool script to run on boot up. This can be easily achieved by using the rc.local boot script and adding this single line for loop.

.. code-block:: bash

  for ETHADP in`ip addr|awk '/eth[0-9]/ {print $2}' | sed 's/://g'`; do ethtool -K ${ETHADP} rx off tx off sg off gso off sgo off tso off; done;

Again you can get more information on the process to disable TCP Offloading on XenServer from here : `XenServer Network Tuning`_


.. _XenServer Network Tuning: http://rackerua.com/2012/07/xenserver-network-tuning/
