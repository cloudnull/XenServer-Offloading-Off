#!/bin/bash
# - title        : Disable ALL Offloading
# - description  : This script will assist in Disabling ALL TCP Offloading.
# - author       : Kevin Carter
# - date         : 2012-05-15
# - version      : 1.0    
# - usage        : bash offloadingdisableforslice.sh
# - notes        : This Disables all offloading for the PIF and VIF and the entire host.  
# - bash_version : >= 3.2.48(1)-release
#### ========================================= ####

SLICEID="$1"; 

SLICEOFFLOADINGOFF(){
	echo "Disabling Offloading for the entire Host";
		for ETHADP in `ip addr|awk '/eth[0-9]/ {print $2}'|sed 's/://g'`; do ethtool -K ${ETHADP} rx off tx off sg off gso off sgo off tso off; done; 

	VMUUID=`xe vm-list name-label=${SLICEID}|awk '/uuid/ {print $5}'`; 

		echo "Disabling Offloading on the VIF for the specified Instance ID.";
			for VIFUUID in `xe vif-list vm-uuid=${VMUUID} | awk '/uuid/ {print $5}'|sed '/^$/d'`; do xe vif-param-set uuid=${VIFUUID} other-config:ethtool-gso=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-ufo=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-tso=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-sg=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-tx=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-rx=”off”; done; 

		echo "Disabling Offloading on the PIF for the specified Instance ID.";
			for PIFUUID in `xe pif-list |awk '/uuid/ {print $5}'|sed '/^$/d'`; do xe pif-param-set uuid=${PIFUUID} other-config:ethtool-gso=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-ufo=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-tso=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-sg=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-tx=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-rx=”off”; done; 

	echo "All Done..."
	echo "All of the TCP Offloading for Instace \"${SLICEID}\" that can be off, has been turned off."

	unset VMUUID;

unset SLICEID; 

}

ALLOFFLOADINGOFF(){
	echo "Disabling Offloading for the entire Host";
		for ETHADP in `ip addr|awk '/eth[0-9]/ {print $2}'|sed 's/://g'`; do ethtool -K ${ETHADP} rx off tx off sg off gso off sgo off tso off; done; 

for INSTANCEID in `xe vm-list | awk '/name-label/' | grep -v 'Control domain' | awk '{print $4}'` 

do 
	VMUUID=`xe vm-list name-label=${INSTANCEID}|awk '/uuid/ {print $5}'`; 
		echo "Offloading done on \"${INSTANCEID}\""
			for VIFUUID in `xe vif-list vm-uuid=${VMUUID} | awk '/uuid/ {print $5}'|sed '/^$/d'`; do xe vif-param-set uuid=${VIFUUID} other-config:ethtool-gso=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-ufo=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-tso=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-sg=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-tx=”off”; xe vif-param-set uuid=${VIFUUID} other-config:ethtool-rx=”off”; done; 
			for PIFUUID in `xe pif-list |awk '/uuid/ {print $5}'|sed '/^$/d'`; do xe pif-param-set uuid=${PIFUUID} other-config:ethtool-gso=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-ufo=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-tso=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-sg=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-tx=”off”; xe pif-param-set uuid=${PIFUUID} other-config:ethtool-rx=”off”; done; 

		unset VMUUID;

	unset INSTANCEID; 

done;

	echo "All Done..."
	echo "All of the TCP Offloading for ALL Instances that can be off, has been turned off."
}

if [ -z "$SLICEID" ];then 
	echo ""; 
	clear
	echo -e "No Command Given, \033[1;31m ** FAIL ** \033[0m";
	echo -e "Use : \033[1;31mxe vm-list\033[0m to see all active Instances. and then provide a Valid Instance ID.";
	echo -e "If you would like to disable \033[1;31mALL\033[0m Offloading for \033[1;31mALL\033[0m VM's use the \033[1;31mALL\033[0m Command.";
	echo '';
		exit 1
			elif [ $1 == "ALL" ];then
			echo ''
			echo -e "This will disable \033[1;31mALL\033[0m TCP Offloading for the entire host on \033[1;31mALL\033[0m Instances."
			read -p "If this is what you intended to do, then press [ Enter ] to continue.  If not Press [ CTRL - C ]"
			echo ''
				ALLOFFLOADINGOFF
					exit 0
else 

          if [ ! `xe vm-list|awk '/name-label/ {print $4}'|grep ${SLICEID}` ];then 
				echo '';echo -e "\033[1;31mNo Slice Found, FAILED\033[0m"; 
				echo "The Instance ID you entered was not found.";
				echo -e "Use : \033[1;31mxe vm-list\033[0m to see all active Instances.";
				echo '';
					exit 1
          fi;

				SLICEOFFLOADINGOFF
					exit 0

fi

exit 0