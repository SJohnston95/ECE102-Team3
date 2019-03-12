%Created by Stephen Johnston
%For ECE102
%3/5/2019
%ECE102 project main
clear all
ljud_LoadDriver
ljud_Constants 
% Open the first found LabJack U3
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error)
Error = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
button_press = [];
i = 1;
l = 1;
f = 0;
active = -1;
active2 = 1
patching = 0;
fprintf('Welcome to your home security system\n Please enter a password: ')
%%%%%%This while loop calls the button detection function and determines
%%%%%%the behavior of the outputs
while 1 > 0
    button_readings = button_detection();
    button_press = [button_press(1:end),button_readings];

%%%%%%This calls the button detection function and places the output into a
%%%%%%vector
    
    
    if (length(button_press) > f)
        if button_readings == 33
        fprintf('#')
        pause(.5)
         f = f + 1;
        else          
        fprintf('%d',button_press(end))
         f = f + 1;
         pause(.5)
        end
    end
%%%%%%This determines if a button was pressed and then prints it only once    
    
    if (button_readings == 33)&(active==-1)
     pwd = button_press(1:end-1);
     button_press = []; 
     fprintf('\nThe lights will now activate\n')
     printing = 1;
     active = 0;
     f = 0;
     both_sensor = 0;
%%%%%%If active is in -1 mode, passwords can be set by the user. I like to
%%%%%%pretend that this is similar to ring -1 access
    elseif (button_readings ==33)&(active>=1)
        if (length(pwd) == length(button_press(1:end-1)))
            if (pwd == button_press(1:end-1))
            fprintf('\nThank you, please enjoy your day\n')
            button_press = [];
            active = 0;
            printing = 1;
%%%%%%%This deactivates the alarm and sends you to the main menu, also
%%%%%%%controlled by the button mechanism
%%%%%%%Note that Alarm is equal to 1 for this setting. This is ring 1
%%%%%%%access. This is the lowest level of access one can reach             end
            end
        elseif (length(pwd) ~= length(button_press(1:end-1)))|(pwd ~= button_press(1:end-1))
            fprintf('\n Incorrect, please enter the correct password\n')
            f = 0;
            button_press = [];
            end
            
%%%%%%This prints out an incorrect password sequence and gives the user 3
%%%%%%chances to type the correct password before the alarm is activated
          if active2 == 4
            alarm();
            active2 = 1;
          end
        
     
        end
    end       
       

 
%%%%%%Control Panel
%%%%%%%Note that Alarm is equal to 0 for this setting. This is ring 0
%%%%%%%access. This is allows one to reach the control panel
        if (active == 0)
        
         if printing == 1
            
            fprintf('\nControl Panel\n')
            fprintf('Note that changing any settings in the Control Panel will require the user to re-enter their password\n')
            fprintf('Please enter one of they keyed inputs\n')
            fprintf('1 for activating all alarm systems\n')
            fprintf('2 for activating the inside alarm system\n')
            fprintf('3 for activating the outside light system\n')
            fprintf('Press 0 to change password\n')
            fprintf('Press # to deactivate alarm\n')
            button_readings = [];
            button_press = [];
            printing = 0; 
   
            pause(3)
         end
            if (button_readings == 1)
            active = 1;
            both_sensor =2;
            button_press = [];
            button_readings = [];
            patching = 0;
            fprintf('\nPlease enter the password\n')
            elseif (button_readings == 2)
            active = 1;
            both_sensor =1;
            button_press = [];
            button_readings = [];
            patching = 0;
            fprintf('\nPlease enter the password\n')
            elseif (button_readings == 3)
            active = 1;
            both_sensor =0;  
            button_press = [];
            button_readings = [];
            patching = 0;
            fprintf('\nPlease enter the password\n')   
            elseif (button_readings == 0)
            active = 1;
            both_sensor = 3;
            button_press = [];
            button_readings = [];
            patching = 0;
            fprintf('\n After entering your previous password, please enter the new password\n')    
            elseif (button_readings == 33)
            error('Deactivating alarm')
            end
        button_press(1:end) = [];
        button_readings = [];
        end
    
    
 
%%%%%%If the alarm is active, then the sensors will be triggered, each by a certain sensor mode

        if (active > 1)&(both_sensor == 2)
        [Error  IR_sensor] = ljud_eGet (ljHandle, LJ_ioGET_DIGITAL_BIT, 7, 1, 0);
        Error_Message(Error)
        [Error  IR_OUTSIDE] = ljud_eGet (ljHandle, LJ_ioGET_DIGITAL_BIT, 6, 1, 0);
        Error_Message(Error)
                if (IR_sensor > 0)
                    alarm();     
                end
                if (IR_OUTSIDE > 0)
                    lights(1);
                    l = l + 1;
                elseif (IR_OUTSIDE < 0)& (l>0)
                   l = l - 1;
                elseif (IR_OUTSIDE < 0)& (1 <=0)
                    lights(0);
                end
                i = 1;
        elseif (active > 1)&(both_sensor == 1)
        [Error  IR_sensor] = ljud_eGet (ljHandle, LJ_ioGET_DIGITAL_BIT, 7, 1, 0);
        Error_Message(Error)
                if (IR_sensor > 0)
                    alarm();     
                end
        elseif (active > 1)&(both_sensor == 0)    
        [Error  IR_OUTSIDE] = ljud_eGet (ljHandle, LJ_ioGET_DIGITAL_BIT, 6, 1, 0);
        Error_Message(Error)
                if (IR_OUTSIDE > 0)
                    lights(1);
                    l = l + 1;
                elseif (IR_OUTSIDE < 0)& (l>0)
                   l = l - 1;
                elseif (IR_OUTSIDE < 0)& (1 <=0)
                    lights(0);
                end
        end
end


function alarm
ljud_LoadDriver
ljud_Constants 
% Open the first found LabJack U3
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error)
Error = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
j=0;
while j < 10
Error = ljud_eGet(ljHandle, LJ_ioPUT_DIGITAL_PORT,9,1, 1);
Error_Message(Error);
pause(.5)
Error = ljud_eGet(ljHandle, LJ_ioPUT_DIGITAL_PORT,9,0, 1);
Error_Message(Error);
j = j + 1;
end

end


function lights(a)
ljud_LoadDriver
ljud_Constants 
% Open the first found LabJack U3
[Error ljHandle] = ljud_OpenLabJack(LJ_dtU3,LJ_ctUSB,'1',1);
Error_Message(Error)
Error = ljud_ePut(ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
if a>0
Error = ljud_eGet(ljHandle, LJ_ioPUT_DIGITAL_PORT,8,0, 1);
Error_Message(Error);
%%%%%%%%Turns on the lights
else
Error = ljud_eGet(ljHandle, LJ_ioPUT_DIGITAL_PORT,8,0, 0);
Error_Message(Error);

end
end