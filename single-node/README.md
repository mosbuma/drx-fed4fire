# drx-fed4fire

create node
- ubuntu 20
- enable internet with script line
    wget -O - -nv --ciphers DEFAULT@SECLEVEL=1 https://www.wall2.ilabt.iminds.be/enable-nat.sh | sudo bash && touch /tmp/internet-enabled
- install docker/docker-compose with
    wget -O - -nv https://raw.githubusercontent.com/mosbuma/drx-fed4fire/master/scripts/install.sh | sudo bash && touch /tmp/docker-installed
    
    
  -> JFed scripts
  
  <?xml version='1.0'?>
  <rspec xmlns="http://www.geni.net/resources/rspec/3" type="request" generated_by="jFed RSpec Editor" generated="2021-05-26T17:07:59.835+02:00" xmlns:emulab="http://www.protogeni.net/resources/rspec/ext/emulab/1" xmlns:delay="http://www.protogeni.net/resources/rspec/ext/delay/1" xmlns:jfed-command="http://jfed.iminds.be/rspec/ext/jfed-command/1" xmlns:client="http://www.protogeni.net/resources/rspec/ext/client/1" xmlns:jfed-ssh-keys="http://jfed.iminds.be/rspec/ext/jfed-ssh-keys/1" xmlns:jfed="http://jfed.iminds.be/rspec/ext/jfed/1" xmlns:sharedvlan="http://www.protogeni.net/resources/rspec/ext/shared-vlan/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.geni.net/resources/rspec/3 http://www.geni.net/resources/rspec/3/request.xsd ">
    <node client_id="node0" exclusive="true" component_manager_id="urn:publicid:IDN+wall1.ilabt.iminds.be+authority+cm">
      <sliver_type name="raw-pc">
        <disk_image name="urn:publicid:IDN+wall1.ilabt.iminds.be+image+emulab-ops:UBUNTU20-64-STD"/>
      </sliver_type>
      <services>
        <execute shell="sh" command="wget -O - -nv --ciphers DEFAULT@SECLEVEL=1 https://www.wall2.ilabt.iminds.be/enable-nat.sh | sudo bash &amp;&amp; touch /tmp/internet-enabled" jfed:finished_flag="/tmp/internet-enabled"/>
        <execute shell="sh" command="wget -O - -nv https://raw.githubusercontent.com/mosbuma/drx-fed4fire/master/scripts/install.sh | sudo bash &amp;&amp; touch /tmp/docker-installed" jfed:finished_flag="/tmp/internet-enabled"/>
      </services>
      <location xmlns="http://jfed.iminds.be/rspec/ext/jfed/1" x="382.0" y="103.5"/>
    </node>
  </rspec>