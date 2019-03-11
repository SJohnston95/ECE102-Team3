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
fprintf('Buttons pressed ')
while 1 > 0
    button_readings = button_detection();
    button_press = [button_press,button_readings(1:end)];
    
    
    if (length(button_press) > f)
    fprintf('%d',button_press(end))
    f = f + 1;
    end
    
    
    if (button_readings == 10)&(active==-1)
     pwd = button_press(1:end-1);
     button_press = [];
     fprintf('\nPlease enter the password\n')
     active = 1;
     f = 0;
    elseif (button_readings ==10)&(active==1)
        if (pwd == button_press(1:end-1))&(length(pwd) == length(button_press))
            fprintf('Thank you, please enjoy your day\n')
            active = 0;
        else
            active = active + 1;
            button_press = [];
             fprintf('\n Incorrect, please enter the correct password\n')
            if active == 4
               alarm();
               active = 1;
            end
        end
    elseif ((button_readings ==10))&(button_press(1:end-1) == 333)
    error('Leaving function') 
    end
        if active > 1
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