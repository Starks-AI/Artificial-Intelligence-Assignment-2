% ------------------------------------------
% Ques 1-A
% Group members :-
% Adit Jain (201851007)
% Deep Shah (201851037)
% Kartikay Sarswat (201851057)
% Pallavi Sharma (201851079)
% Devansh Agarwal (201851038)
% 
% --------------------------------------------

max_steps = 50;
rewards_array = zeros(max_steps, 2);
i = 1;
total = zeros(max_steps);

for epsilon = [0.01, 0.1, 0.3]
    rewards_array(:, :, i) = 0;
    step = 1;
    
    while step <= max_steps
        % We undergo exploration i.e. take random samples
        
        if rand < epsilon || step == 1
            action = randi(2);
            value = binaryBanditA(action);
            total(step,i) = value;
            if step > 1
                total(step,i) = total(step,i) + total(step - 1,i);
            end
            rewards_array(step, :, i) = [value, action];
            
        else
            % We undergo exploitation i.e. take maximum values
            action_1 = 0;
            action_2 = 0;
            
            for s = 1:step
                
                if rewards_array(s, 1, i) == 1
                    if rewards_array(s, 2, i) == 1
                        action_1 = action_1 + 1;
                    else
                        action_2 = action_2 + 1;
                    end
                end
                
            end
            
            action = 1;
            if action_2 > action_1
                action = 2;
            end
            
            value = binaryBanditA(action);
            total(step,i) = value + total(step - 1,i);
            rewards_array(step, :, i) = [value, action];
        end
        
        step = step + 1;
    end
    
    i = i + 1;
end

plot(rewards_array(:,1,1))
hold on
plot(rewards_array(:,1,2))
plot(rewards_array(:,1,3))
hold off
ylim([-1,2])
xlabel('Time Steps')
ylabel('Reward')
legend('epsilon = 0.01','epsilon = 0.1', 'epsilon = 0.3','Location','northwest')
% plot(total(:,1))
% hold on
% plot(total(:,2))
% plot(total(:,3))
% hold off
% ylim([0,10])
% xlabel('Time Steps')
% ylabel('Total Successes')
% legend('epsilon = 0.01','epsilon = 0.1', 'epsilon = 0.3','Location','northwest')
% title('Binary Bandit A - (epsilon = 0.01, 0.1, 0.3)')