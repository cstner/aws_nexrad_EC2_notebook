# Updated introduction to S3, Boto and Nexrad on S3
Adapated from and thank you to Scott Collis, ARM precipitation radar instrument translator (see <a href="https://github.com/openradar/AMS_radar_in_the_cloud/blob/master/notebooks/introduction%20to%20S3%2C%20Boto%20and%20Nexrad%20on%20S3%20with%20a%20hurricane%20chaser.ipynb">here</a>) and the original tutorial by Valliappa Lakshmanan, formerly at Climate Corp now at Google.  This version is updated to use Ubuntu20 and Python 3.8.

## Pre-Worksop Instructions

Please follow the instructions here:
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html
Note: Not all steps are compulsory, but at the very minimum the first step needs to be completed and Amazon needs to verify your account.

## Starting and Provisioning an EC2 Instance

### Overview

This course will be taught using Jupyter [1] notebooks hosted on an Amazon Web Services (AWS) Elastic Cloud Compute (EC2) instance. The aim of these instructions is to: Start an EC2 instance with the correct access permissions and use the key provided to log in, run some pre-defined scripts to provision the EC2 instance with Anaconda Python [2] and the tools required for the course and, finally, to start the Jupyer notebook server and connect to it using a web browser.

1) Point your browser at https://aws.amazon.com/ and click "sign into the console" in the top right hand corner.
2) Log in with the credentials you generated using the pre-course instructions, once authenticated this will take you to the console which will look similar to this:
![homescreen](https://user-images.githubusercontent.com/66844762/161318007-b23fb837-48eb-4987-af3f-568b57d96a72.png)

3) Type "ec2" into the text box under "AWS services" and click the first option in the drop down box. This will land you on a page that looks similar to this (of course you will not have existing snapshots etc...):
![ec2_dash](https://user-images.githubusercontent.com/66844762/161318066-674e7e9f-58b1-4dbb-bfe4-223cd90bd07b.png)

4) If it is not expanded out already, expand Instances:
![ec2_instances_twistie](https://user-images.githubusercontent.com/66844762/161318181-67539127-49b6-4f50-8384-c2806c7d4d80.png)
... and click on "Instances" and in the menu below it, and you will be greeted by this screen:
![ec2_instances](https://user-images.githubusercontent.com/66844762/161319182-e7aeed72-30b7-4641-a39f-01d3dd6ac624.png)
You can now click on "Launch Instance"

5) You will be greeted by a page that looks like this:
![OS_choose](https://user-images.githubusercontent.com/66844762/161318310-cc7e4be9-378a-450e-a0a2-dee207273719.png)

click select next to the "*Ubuntu Server 20.04 LTS (HVM), SSD Volume Type*" option. The next page asks you to click a radio button next to the "size" of the machine you want to start. While you are experimenting use "t2.micro" which gives you a 1GB 1CPU EC2 instance. For the course 1GB will not cut it, *select "m4.large". *
![select_ec2_size](https://user-images.githubusercontent.com/66844762/161318324-782ab631-2c86-44af-83d5-c9ca3e7fc83c.png)

6) Once your selection has been made click the gray button "Next: Configure Instance Details".
7) This page can be left as all defaults... Click the gray button "Next: Add Storage"
8) Change the *Size (GiB)* to 100.
![size_to_100](https://user-images.githubusercontent.com/66844762/161318414-37e9d191-ed1d-4424-afd8-57b876a86d7a.png)
Click the gray button "Next: Add Tags"

9) No need to add tags for the purposes of this course... Once more click the gray button "Next: configure Security Group"

10) Now we have work to do! We need to configure our instance to be able to serve the Jupyter notebook via HTTPS on port 8888. You will see a page similar to that below. Make sure "Create a new security group" is checked, later you can select "select and existing group" to save you time! Enter a simple name for the Security group name like "j_sever". Enter something descriptive for the Description.
![ssh](https://user-images.githubusercontent.com/66844762/161318469-1366d499-5e3f-4f35-9d23-f08fe4ec7a55.png)
We need to configure to allow connections from any IP to ports 443 (HTTPS) and 8888 (where Jupyter listens). Click "Add Rule". This will create a new row. On the new row the drop down box on the left will default to "Custom TCP Rule". Click it and select "HTTPS". Then click "Add Rule" again but this time, in the new row leave the drop down on "Custom TCP Rule". In that same, third, row enter "8888" into "Port Range" column and "0.0.0.0/0" in the source column. Once done it should look like this:
![https_2](https://user-images.githubusercontent.com/66844762/161318938-f867e7cd-2c15-4d77-95da-bf254529b71e.png)

11) Now we can click the blue button "Review and Launch". You will be presented with a page like this for one final check.
![review](https://user-images.githubusercontent.com/66844762/161318615-61b428f5-9dba-413c-bc21-2db082277870.png)

12) click Launch and a dialog pops up like this:
<img width="722" alt="pem" src="https://user-images.githubusercontent.com/66844762/161318626-fc6924c1-d7fd-46dc-b962-30e0b11ee37b.png">

The top drop down can be either "use existing pair", "create new pair" or "proceed without pair". Select "Create new pair", in the text entry below think of a good name (eg "jupyter") and click on download key pair. A save dialog will pop up REMEBER WHERE YOU SAVED IT! we will call this "/path/to/key/" in future reference so the key is at "/path/to/key/key_name.pem".
Once you have downloaded the key the blue "Launch Instance" button will be un-grayed and you can click it!

13) You will now have a screen like this (after a spinning wheel screen):
<img width="1244" alt="launch_status" src="https://user-images.githubusercontent.com/66844762/161318643-81fb7851-cb18-4abe-826e-7cd238fc3ed1.png">

Click on the hyperlink starting with "i". You will get a window like the one below. Some entries may be blank until the instance comes up.
![ec2_launching2](https://user-images.githubusercontent.com/66844762/161321858-f7a00aeb-8883-4678-8a53-998035ab3cf4.png)


### Second: Logging into your instance

14) You will need an SSH client. These instructions will vary from client to client. Initially this tutorial will have instructions for a terminal based client available on Linux and MacOS/OSX.

select your instance in the list of instances and click “Connect”. You will see this window:
![ssh_connect](https://user-images.githubusercontent.com/66844762/161322231-65d1d69d-dd76-4e59-9854-ba9cb7c2d535.png)

Click on the copy button near <code>chmod 400</code>:
![chmod400](https://user-images.githubusercontent.com/66844762/161322359-347366d7-a7c8-4cfa-8754-1a166769777e.png)

Go to a terminal and paste the command to ensure your key is not publicly viewable.

15) Then Click on the copy button near <code>ssh-i</code>:
![ssh_cmd](https://user-images.githubusercontent.com/66844762/161319609-7b0d2e4a-e130-4171-b6f3-3109d6a29957.png)

Paste this command into your terminal. Hit enter and answer "yes" when it asks if you want to continue connecting. 
Congrats! You are now logged into your instance!

You should see something like this:
<img width="683" alt="terminal" src="https://user-images.githubusercontent.com/66844762/161319634-53f38b8c-afa1-413e-a22d-7afefd7049b4.png">



### Third: Provisioning your instance

16) We now need to load on software we use for the course. This will involve executing a shell script located at ~/setup.sh.

In the shell, type the following and hit enter:<br>
<code>chmod +x ~/.setup.sh</code>

Then, type the following and hit enter:<br>
<code>~/.setup.sh</code>


17) After some time the script will prompt you for a password. Enter something, enter it again.. remember it!
  
  

### Fourth: Starting the Jupyter notebook

18) After the script finishes it should finish with a set of lines like this:
<img width="638" alt="install_complete" src="https://user-images.githubusercontent.com/66844762/161319773-0206ef38-4348-478b-8508-9cdb9751cb5e.png">

19) In the command line run the lines (By copy pasting if you choose):<br>
<code>. ~/.bashrc</code>

<code>jupyter notebook —certfile=~/certs/mycert.pem —keyfile ~/certs/mycert.key</code>
<br><br>

20) The Jupyter notebook has now started! Huzzah! Your terminal should look like this:
<img width="878" alt="jupyter_start" src="https://user-images.githubusercontent.com/66844762/161319920-79bfedd2-363b-4eb5-b830-bdc4f14f3d12.png">

  
One last step.. You can see a line after "Our GUESS (prone to breakage) is:". This is the expected location of your Jupyter notebook server.. Copy that line to the clipboard and open a browser window.. Our example here uses Firefox. Paste the address in the "Search or enter address" text entry box and press enter. You should get a screen like this:
<img width="878" alt="firefox" src="https://user-images.githubusercontent.com/66844762/161319943-1ee89d1c-af76-42b6-b13c-1b284173dc62.png">


<b>ONLY EVER DO THIS FOR SITES YOU COMPLETELY TRUST.</b> Click "Advanced" and then click "Add Exception". A window will drop down, click "Confirm security exception". Bingo you should now be presented with a page asking for your password.. enter it and you are good to go!

NOTE FOR SAFARI USERS: Do not just hit "continue".. This will allow you to get into the notebook server but the kernel will not be able to connect.. Click "Show Certificate" and click the upper left hand radio button to accept the generate certificate.

[1] http://jupyter.org/ <br>
[2] https://www.continuum.io/downloads

