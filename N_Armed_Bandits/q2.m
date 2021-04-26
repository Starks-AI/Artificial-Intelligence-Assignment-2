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

max_steps = 10000;
reward_array = zeros(max_steps, 2);
i = 1;
total = zeros(max_steps);
count_Actions = zeros(10);
for epsilon = [0.01, 0.1, 0.3]
    total(:,i) = 0;
    reward_array(:, :, i) = 0;
    step = 1;
    count_Actions(:,i) = 0;
    
    while step <= max_steps
        
        % We undergo exploration i.e. take random samples
        if rand < epsilon || step == 1
            action = randi(10);
            value = bandit(action);
            total(step,i) = value;
            if step > 1
                total(step,i) = total(step,i) + total(step - 1,i);
            end
            reward_array(step, :, i) = [value, action];
            
       % We undergo exploitation i.e. take maximum values
        else
            actions = zeros(10, 2);
            
            for s = 1:(step-1)
                actions(reward_array(s,2,i), 1) = actions(reward_array(s,2,i),1)+reward_array(s,1,i);
                actions(reward_array(s,2,i), 2) = actions(reward_array(s,2,i),2)+1;
            end
            
            action = 1;
            expected_Return = 0;
            a = 1;
            for aa = actions
                temp = aa(1) / aa(2);
                if temp > expected_Return
                    expected_Return = temp;
                    action = a;
                end
                a = a + 1;
            end
            
            value = bandit(action);
            total(step,i) = value + total(step - 1,i);
            reward_array(step, :, i) = [value, action];
            count_Actions(:,i) = actions(:,2);
        end    
        
        step = step + 1;
    end
    
    i = i + 1;
end

figure(1);
plot(reward_array(:,2,2));
xlabel('Time Steps')
ylabel('Actions')
title('10 armed Bandit - (epsilon = 0.1)')

figure(2);
scatter(1:10,count_Actions(:,2));
xlabel('Actions')
ylabel('# times taken')
title('10 armed Bandit - (epsilon = 0.1)')

figure(3);
plot(total(:,2))
xlabel('Time Steps')
ylabel('Total Value Received')
title('10 armed Bandit - (epsilon = 0.1)')

average_reward = zeros(max_steps);
for i = 1:max_steps
    average_reward(i) = total(i,2) / i;
end

% figure(1);
% plot(average_reward(:,1));
% xlabel('Time Steps')
% ylabel('Average Reward')
% title('10 armed Bandit - (epsilon = 0.1)')
% plot(total(:,1))
% hold on
% plot(total(:,2))
% plot(total(:,3))
% hold off
% xlabel('Time Steps')
% ylabel('Total Successes')
% title('10 armed Bandit - (epsilon = 0.1)')