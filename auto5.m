global key
InitKeyboard();
brick.SetColorMode(4, 2);
autoDrive = 0; %start in manual mode
setting = 0; 


    while 1
        pause(0.1);
        
        
        if (autoDrive == 0) %manual mode
            pause(0.1);
            
            brick.StopMotor('AB');
            
            switch key
                case 'w'
                    brick.MoveMotor('A', 50);
                    brick.MoveMotor('B', 52);
                case 's'     
                    brick.MoveMotor('A', -50);
                    brick.MoveMotor('B', -52);
                case 'a' 
                    brick.StopMotor('AB');
                    brick.MoveMotor('A', 50);
                    brick.MoveMotor('B', -50);
                case 'd'
                    brick.StopMotor('AB'); 
                    brick.MoveMotor('B', 50)
                    brick.MoveMotor('A', -50);
                case 'r'
                    brick.StopMotor('AB'); 
                case 'h' %switch to auto mode
                    autoDrive = 1;
                    setting = 'drive';     
                case 'c' %pickup mechanism up
                    brick.MoveMotor('C', 10);
                case 'v' %pickup mechanism down
                    brick.MoveMotor('C', -10);
                case 'b' %pickup stop
                    brick.StopMotor('C');
            end
        end
        
          if (autoDrive == 1)
              switch setting
                  case 'drive'
                      brick.MoveMotor('A', 50);
                      brick.MoveMotor('B', 52); 
                      
                      
                      dx = brick.UltrasonicDist(2);
                      if (dx > 55) %right turn has been detected
                          setting = 'turn';
                      end
                      
                      if (dx < 10)%too close to right wall
                        brick.MoveMotor('B', 52);
                        brick.MoveMotor('A', 60);
                        
                      end
                      
                      if ((dx > 30) && (dx < 45)) %too close to left wall
                        brick.MoveMotor('A', 50);
                        brick.MoveMotor('B', 60);
                      end

                      reading = brick.TouchPressed(1);
                      reading2 = brick.TouchPressed(3);%dead end detection
                      
                      if ((reading == 1) || (reading2 == 1)) 
                          setting = 'deadEnd'; 
                      end
                   
                      color = brick.ColorCode(4); %color detection
                      if (color == 5) %stop sign (red)
                          brick.StopMotor('AB');
                          pause(1);
                            brick.MoveMotor('A', 50);
                            brick.MoveMotor('B', 52); %drives with sensor
                          pause(.33); %disabled for a moment to not get stuck in loop
                      end
                      if (color == 2) %if blue
                          autoDrive = 0;
                      end
                      if (color == 3) %if green
                          autoDrive = 0;
                      end
                      
                  case 'turn' %~90 degree right turn
                      	brick.StopMotor('AB'); 
                        brick.MoveMotor('B', 50)
                        brick.MoveMotor('A', -50);
                        pause(.48);
                        brick.StopMotor('B');

                        brick.MoveMotor('AB', 50);%drive forward
                        pause(2);
                      
                        setting = 'drive';

                  case 'deadEnd' %do 180 degree turn
                      
                            
                            
                        brick.StopMotor('AB'); 
                        brick.MoveMotor('AB', -50); %back up
                        pause(1);
                       
                        
                        %manually stop car
                        
                        reading = brick.TouchPressed(1);
                        reading2 = brick.TouchPressed(3);
                        if ((reading == 1) || (reading2 == 1))
                            manualStop = 1;
                            autoDrive = 0; 
                        end
                        
                        brick.StopMotor('AB');  %180 turn
                        brick.MoveMotor('A', 50);
                        brick.MoveMotor('B', -50);
                        pause(.875);
                        brick.StopMotor('AB');
                        setting = 'drive';
              
              end
          end       
    end