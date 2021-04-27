import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import poisson
import sys

variant = True

class gbike:

    max_bicycles = 20
    gamma = 0.9
    credit_reward = 10
    moving_reward = -2
    if(variant): second_parking_lot_reward = -4


class poisson_:

    def __init__(self, l):
        self.l = l

        e = 0.01

        self.a = 0
        state = 1
        self.vals = {}
        s = 0

        while(1):
            if state == 1:
                temp = poisson.pmf(self.a, self.l)
                if(temp <= e):
                    self.a+=1
                else:
                    self.vals[self.a] = temp
                    s += temp
                    self.b = self.a+1
                    state = 2
            elif state == 2:
                temp = poisson.pmf(self.b, self.l)
                if(temp > e):
                    self.vals[self.b] = temp
                    s += temp
                    self.b+=1
                else:
                    break

        added_val = (1-s)/(self.b-self.a)
        for key in self.vals:
            self.vals[key] += added_val


    def f(self, n):
        try:
            Ret_value = self.vals[n]
        except(KeyError):
            Ret_value = 0
        finally:
            return Ret_value


class location:

    def __init__(self, req, ret):
        self.a = req
        self.b = ret
        self.poisson_a = poisson_(self.a)
        self.poisson_b = poisson_(self.b)


def apply_action(state, action):
    return [max(min(state[0] - action, gbike.max_bicycles),0) , max(min(state[1] + action, gbike.max_bicycles),0)]


def expected_reward(state, action):
    global value

    r = 0 #reward
    new_state = apply_action(state, action)

    if(variant):
        if action <= 0:
            r = r + gbike.moving_reward * abs(action)
        else:
            r = r + gbike.moving_reward * (action - 1)


        if new_state[0] > 10:
            r = r + gbike.second_parking_lot_reward

        if new_state[1] > 10:
            r = r + gbike.second_parking_lot_reward

    else:
        r = r + gbike.moving_reward * abs(action)


    for Aa in range(A.poisson_a.a, A.poisson_a.b):
        for Ba in range(B.poisson_a.a, B.poisson_a.b):
            for Ab in range(A.poisson_b.a, A.poisson_b.b):
                for Bb in range(B.poisson_b.a, B.poisson_b.b):
                    p = A.poisson_a.vals[Aa] * B.poisson_a.vals[Ba] * A.poisson_b.vals[Ab] * B.poisson_b.vals[Bb]

                    valid_requests_A = min(new_state[0], Aa)
                    valid_requests_B = min(new_state[1], Ba)

                    rew = (valid_requests_A + valid_requests_B)*(gbike.credit_reward)

                    new_s = [0,0]
                    new_s[0] = max(min(new_state[0] - valid_requests_A + Ab, gbike.max_bicycles),0)
                    new_s[1] = max(min(new_state[1] - valid_requests_B + Bb, gbike.max_bicycles),0)

                    #Bellman's equation
                    r += p * (rew + gbike.gamma * value[new_s[0]][new_s[1]])

    return r


def policy_evaluation():

    global value

    e = policy_evaluation.e

    policy_evaluation.e /= 10

    while(1):
        D = 0

        for i in range(value.shape[0]):
            for j in range(value.shape[1]):

                old_val = value[i][j]
                value[i][j] = expected_reward([i,j], policy[i][j])

                D = max(D, abs(value[i][j] - old_val))
                sys.stdout.flush()

        sys.stdout.flush()

        if D < e:
            break


def policy_improvement():

    global policy

    policy_stable = True
    for i in range(value.shape[0]):
        for j in range(value.shape[1]):
            old_action = policy[i][j]

            max_act_val = None
            max_act = None

            T12 = min(i,5)
            T21 = -min(j,5)

            for act in range(T21,T12+1):
                exp_r = expected_reward([i,j], act)
                if max_act_val == None:
                    max_act_val = exp_r
                    max_act = act
                elif max_act_val < exp_r:
                    max_act_val = exp_r
                    max_act = act

            policy[i][j] = max_act

            if old_action!= policy[i][j]:
                policy_stable = False

    return policy_stable


def save_policy():
    ax = sns.heatmap(policy, linewidth=0.5)
    ax.invert_yaxis()
    if(variant):
        plt.savefig('policyVar.png')
    else:
        plt.savefig('policy.png')
    plt.close()



A = location(3,3)
B = location(4,2)

value = np.zeros((gbike.max_bicycles+1, gbike.max_bicycles+1))
policy = value.copy().astype(int)
policy_evaluation.e = 50

while(1):
    policy_evaluation()
    p = policy_improvement()
    if p == True:
        break

print(policy)
save_policy()
