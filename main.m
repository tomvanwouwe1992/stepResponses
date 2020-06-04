clear all; close all; clc;
import casadi.*

% Parameters of our walker (masses, lengths inertias, ...)
m1 = 3.2; m5 = 3.2;
m2 = 6.8; m4 = 6.8;
m3 = 20;
I1 = 0.93; I5 = 0.93;
I2 = 1.08; I4 = 1.08;
I3 = 2.22;
l1 = 0.4; l5 = 0.4;
l2 = 0.4; l4 = 0.4;
l3 = 0.625;
lc1 = l1 - 0.128; lc5 = lc1;
lc2 = l2-0.163; lc4 = lc2;
lc3 = 0.2;
g = 9.81;

% Declare CasADi variables that will be used to create CasADi function
q1_MX = MX.sym('q1_MX',1); q2_MX = MX.sym('q2_MX',1); q3_MX = MX.sym('q3_MX',1); q4_MX = MX.sym('q4_MX',1); q5_MX = MX.sym('q5_MX',1);
dq1_MX = MX.sym('dq1_MX',1); dq2_MX = MX.sym('dq2_MX',1); dq3_MX = MX.sym('dq3_MX',1); dq4_MX = MX.sym('dq4_MX',1); dq5_MX = MX.sym('dq5_MX',1);
ddq1_MX = MX.sym('ddq1_MX',1); ddq2_MX = MX.sym('ddq2_MX',1); ddq3_MX = MX.sym('ddq3_MX',1); ddq4_MX = MX.sym('ddq4_MX',1); ddq5_MX = MX.sym('ddq5_MX',1);
T1_MX = MX.sym('T1_MX',1); T2_MX = MX.sym('T2_MX',1); T3_MX = MX.sym('T3_MX',1); T4_MX = MX.sym('T4_MX',1); T5_MX = MX.sym('T5_MX',1);
Fpush_MX = MX.sym('Fpush_MX',1);
% Generate a CasADi function for the implicit constraint in order to satisfy the system dynamics --> f(T,q,dq,ddq) == 0
eq_SysDyn_Error = eq_SysDyn(Fpush_MX,I1,I2,I3,I4,I5,T1_MX,T2_MX,T3_MX,T4_MX,T5_MX,ddq1_MX,ddq2_MX,ddq3_MX,ddq4_MX,ddq5_MX,dq1_MX,dq2_MX,dq3_MX,dq4_MX,dq5_MX,g,l1,l2,l3,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1_MX,q2_MX,q3_MX,q4_MX,q5_MX);
f_eq_SysDyn_Error_Nominal = Function('f_eq_SysDyn_Error_Nominal',{Fpush_MX,T1_MX,T2_MX,T3_MX,T4_MX,T5_MX,ddq1_MX,ddq2_MX,ddq3_MX,ddq4_MX,ddq5_MX,dq1_MX,dq2_MX,dq3_MX,dq4_MX,dq5_MX,q1_MX,q2_MX,q3_MX,q4_MX,q5_MX},{eq_SysDyn_Error});

% Time horizon and mesh size for simulation
dt = 0.01;  % Mesh size
T = 1.0;    % Stride time
N = T/dt;   % Nr mesh intervals
% N = 200;
time = 0:dt:T;
D = 0.4; % Half stride length

opti = casadi.Opti(); % Create opti instance

% Create optimization variables
q1 = opti.variable(1,N+1);   q2 = opti.variable(1,N+1);   q3 = opti.variable(1,N+1);   q4 = opti.variable(1,N+1); , q5 = opti.variable(1,N+1);
dq1 = opti.variable(1,N+1);  dq2 = opti.variable(1,N+1);  dq3 = opti.variable(1,N+1);  dq4 = opti.variable(1,N+1);  dq5 = opti.variable(1,N+1);
ddq1 = opti.variable(1,N);   ddq2 = opti.variable(1,N);   ddq3 = opti.variable(1,N);   ddq4 = opti.variable(1,N);   ddq5 = opti.variable(1,N);
T1 = opti.variable(1,N);     T2 = opti.variable(1,N);     T3 = opti.variable(1,N);     T4 = opti.variable(1,N);     T5 = opti.variable(1,N);
% dt = opti.variable(1,1); opti.set_initial(dt, 0.005); opti.subject_to(0.002 < dt < 0.1);


% Crude bounds on the segment orientations
opti.subject_to(-pi/2 < q1 < pi/2);
opti.subject_to(-pi/2 < q2 < pi/2);
opti.subject_to(-pi/2 < q3 < pi/2);
opti.subject_to(-pi/2 < q4 < pi/2);
opti.subject_to(-pi/2 < q5 < pi/2);

% Physiological joint limits
opti.subject_to(-pi < q1 - q2 < 0); % Knee joint limit (no hyperflexion)
opti.subject_to(-pi < q5 - q4 < 0); % Knee joint limit (no hyperflexion)


% Generate an initial guess for the positions (done very naively!)
q1_init = -pi/8; q2_init = pi/6; q3_init = -pi/6; q4_init = -pi/8; q5_init = -pi/6;
q1_final = -pi/6; q2_final = -pi/8; q3_final = 0; q4_final = pi/6; q5_final = -pi/8;
q1guess = linspace( q1_init, q1_final, N+1);
q2guess = linspace( q2_init, q2_final, N+1);
q3guess = linspace( q3_init, q3_final, N+1);
q4guess = linspace( q4_init, q4_final, N+1);
q5guess = linspace( q5_init, q5_final, N+1);

opti.set_initial(q1, q1guess);
opti.set_initial(q2, q2guess);
opti.set_initial(q3, q3guess);
opti.set_initial(q4, q4guess);
opti.set_initial(q5, q5guess);


opti.subject_to(-60 < T1 < 60);
opti.subject_to(-100 < T2 < 100);
opti.subject_to(-100 < T3 < 100);
opti.subject_to(-100 < T4 < 100);
opti.subject_to(-100 < T5 < 100);

J = 0;
for k=1:N
    % State at mesh point k
    q1k = q1(:,k);     q2k = q2(:,k);     q3k = q3(:,k);     q4k = q4(:,k);     q5k = q5(:,k);
    dq1k = dq1(:,k);   dq2k = dq2(:,k);   dq3k = dq3(:,k);   dq4k = dq4(:,k);   dq5k = dq5(:,k);
    
    % Control/lifted state variable for mesh k
    ddq1k = ddq1(:,k); ddq2k = ddq2(:,k); ddq3k = ddq3(:,k); ddq4k = ddq4(:,k); ddq5k = ddq5(:,k);
    T1k = T1(:,k);     T2k = T2(:,k);     T3k = T3(:,k);     T4k = T4(:,k);     T5k = T5(:,k);
    
    % State at mesh point k+1
    q1k_plus = q1(:,k+1);     q2k_plus = q2(:,k+1);     q3k_plus = q3(:,k+1);     q4k_plus = q4(:,k+1);     q5k_plus = q5(:,k+1);
    dq1k_plus = dq1(:,k+1);   dq2k_plus = dq2(:,k+1);   dq3k_plus = dq3(:,k+1);   dq4k_plus = dq4(:,k+1);   dq5k_plus = dq5(:,k+1);
       
    % Collect state at k and k+1
    Xk = [q1k; q2k; q3k; q4k; q5k; dq1k; dq2k; dq3k; dq4k; dq5k];
    Xk_next = [q1k_plus; q2k_plus; q3k_plus; q4k_plus; q5k_plus; dq1k_plus; dq2k_plus; dq3k_plus; dq4k_plus; dq5k_plus];
    
    % Collect state derivative (we use backward (not forward) Euler!)
    Uk = [dq1k_plus; dq2k_plus; dq3k_plus; dq4k_plus; dq5k_plus; ddq1k; ddq2k; ddq3k; ddq4k; ddq5k];
    
    % Integration
    opti.subject_to(eulerIntegrator(Xk,Xk_next,Uk,dt) == 0);
       
    % Dynamics error (backward Euler - derivative at k+1)
    
    if k > 1 && k < 12
        Fpush = 200;
    else
        Fpush = 0;
    end

    error = f_eq_SysDyn_Error_Nominal(Fpush,T1k,T2k,T3k,T4k,T5k,ddq1k,ddq2k,ddq3k,ddq4k,ddq5k,dq1k_plus,dq2k_plus,dq3k_plus,dq4k_plus,dq5k_plus,q1k_plus,q2k_plus,q3k_plus,q4k_plus,q5k_plus);
    opti.subject_to(error == 0);
    
    % Cost function contributions
    % Main term is torque minimization, we add minimization of
    % accelerations for regularization (contribution is confirmed to be
    % small)
    COMk = COM(l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1k,q2k,q3k,q4k,q5k);
    opti.subject_to(COMk(2) > 0.7);
    xCOMk = xCOM(dq1k,dq2k,dq3k,dq4k,dq5k,g,l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1k,q2k,q3k,q4k,q5k);
    J = J + (T1k.^2 + T2k.^2 + T3k.^2 + T4k.^2 + T5k.^2)*dt + 1e-3*(ddq1k.^2 + ddq2k.^2 + ddq3k.^2 + ddq4k.^2 + ddq5k.^2)*dt + 1e3*xCOMk^2*dt;
    
    % Joint locations in x-y plane
    P_J = JointPos(l1,l2,l3,l4,l5,q1k,q2k,q3k,q4k,q5k);
    
    % Impose that swing foot does not penetrate ground
    opti.subject_to(P_J(10) > -1e-4);
    
end
xCOMfinal = xCOM(dq1k,dq2k,dq3k,dq4k,dq5k,g,l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1k,q2k,q3k,q4k,q5k);


opti.subject_to(q1(1) == -10*pi/180);
opti.subject_to(q2(1) == 10*pi/180);
opti.subject_to(q3(1) == -5*pi/180);
opti.subject_to(q4(1) == 20*pi/180);
opti.subject_to(q5(1) == -20*pi/180);

opti.subject_to(dq1(1) == 0*pi/180);
opti.subject_to(dq2(1) == 0*pi/180);
opti.subject_to(dq3(1) == 0*pi/180);
opti.subject_to(dq4(1) == 0*pi/180);
opti.subject_to(dq5(1) == 0*pi/180);

opti.subject_to(ddq1(1) == 0);
opti.subject_to(ddq2(1) == 0);
opti.subject_to(ddq3(1) == 0);
opti.subject_to(ddq4(1) == 0);
opti.subject_to(ddq5(1) == 0);

% Periodicity constraint (part is in the heel strike map)
JointPosFinal = JointPos(l1,l2,l3,l4,l5,q1(:,end),q2(:,end),q3(:,end),q4(:,end),q5(:,end));
opti.subject_to(JointPosFinal(10,:) == 0); %  Impose step length of 1 meter
opti.subject_to(JointPosFinal(9,:)  > xCOMfinal+0.02); %  Impose step length of 1 meter
opti.subject_to(0 + 0.02  < xCOMfinal); %  Impose step length of 1 meter

% Impose that simulation start and end is at 'toe-off' and 'heel-strike'.
% We do this by saying that the swing foot should have a positive
% y-velocity at the start (toe-off) and negative at the end (heel strike).
JointVelInit = JointVel(dq1(:,1),dq2(:,1),dq3(:,1),dq4(:,1),dq5(:,1),l1,l2,l3,l4,l5,q1(:,1),q2(:,1),q3(:,1),q4(:,1),q5(:,1));
JointVelFinal = JointVel(dq1(:,end),dq2(:,end),dq3(:,end),dq4(:,end),dq5(:,end),l1,l2,l3,l4,l5,q1(:,end),q2(:,end),q3(:,end),q4(:,end),q5(:,end));
opti.subject_to(JointVelInit(10) > 0);
opti.subject_to(JointVelFinal(10) < 0);

% Define cost
opti.minimize(J);

% Create an NLP solver
optionssol.ipopt.linear_solver = 'mumps';
optionssol.ipopt.constr_viol_tol = 1e-10;
optionssol.ipopt.dual_inf_tol = 1e-8;
optionssol.ipopt.compl_inf_tol = 1e-6;
optionssol.ipopt.max_iter = 10000;
% optionssol.ipopt.hessian_approximation = 'limited-memory';
optionssol.ipopt.mu_strategy = 'adaptive';
opti.solver('ipopt',optionssol);

diary('2D-gait_diary.txt');
sol = opti.solve();
diary off
% dtFinal = sol.value(dt);
% time = 0:sol.value(dt):sol.value(dt)*(N);


% Plot the torques, positions and velocities
T1_sol = sol.value(T1);
T2_sol = sol.value(T2);
T3_sol = sol.value(T3);
T4_sol = sol.value(T4);
T5_sol = sol.value(T5);
figure(1)
plot(time(1:end-1),T1_sol,time(1:end-1),T2_sol,time(1:end-1),T3_sol,time(1:end-1),T4_sol,time(1:end-1),T5_sol);
legend('stance ankle','stance knee','stance hip','swing hip','swing knee');
xlabel(['time [s]'])
ylabel(['Torque [Nm]'])

q1_sol = sol.value(q1);
q2_sol = sol.value(q2);
q3_sol = sol.value(q3);
q4_sol = sol.value(q4);
q5_sol = sol.value(q5);
relativeJointPos = relativeJointPos(q1_sol,q2_sol,q3_sol,q4_sol,q5_sol);
figure(2)
plot(time,180/pi*relativeJointPos(1,:),time,180/pi*relativeJointPos(2,:),time,180/pi*relativeJointPos(3,:),time,180/pi*relativeJointPos(4,:),time,180/pi*relativeJointPos(5,:));
legend('stance ankle','stance knee','stance hip','swing hip','swing knee');
xlabel(['time [s]'])
ylabel(['segment pos [�]'])

dq1_sol = sol.value(dq1);
dq2_sol = sol.value(dq2);
dq3_sol = sol.value(dq3);
dq4_sol = sol.value(dq4);
dq5_sol = sol.value(dq5);
relativeJointVel = relativeJointVel(dq1_sol,dq2_sol,dq3_sol,dq4_sol,dq5_sol);
figure(3)
plot(time,180/pi*relativeJointVel(1,:),time,180/pi*relativeJointVel(2,:),time,180/pi*relativeJointVel(3,:),time,180/pi*relativeJointVel(4,:),time,180/pi*relativeJointVel(5,:));
legend('stance ankle','stance knee','stance hip','swing hip','swing knee');
xlabel(['time'])
ylabel(['segment vel [�]'])

ddq1_sol = sol.value(ddq1);
ddq2_sol = sol.value(ddq2);
ddq3_sol = sol.value(ddq3);
ddq4_sol = sol.value(ddq4);
ddq5_sol = sol.value(ddq5);

% COM and dCOM and xCOM
COMresult = COM(l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1_sol,q2_sol,q3_sol,q4_sol,q5_sol);
dCOMresult = dCOM(dq1_sol,dq2_sol,dq3_sol,dq4_sol,dq5_sol,l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1_sol,q2_sol,q3_sol,q4_sol,q5_sol);
xCOMresult = xCOM(dq1_sol,dq2_sol,dq3_sol,dq4_sol,dq5_sol,g,l1,l2,l4,lc1,lc2,lc3,lc4,lc5,m1,m2,m3,m4,m5,q1_sol,q2_sol,q3_sol,q4_sol,q5_sol);

% Reconstruct cost function
J_torque = (sumsqr(T1_sol) + sumsqr(T2_sol) + sumsqr(T3_sol) + sumsqr(T4_sol) + sumsqr(T5_sol))*dt;
J_ddq = 1e-1*(sumsqr(ddq1_sol) + sumsqr(ddq2_sol) + sumsqr(ddq3_sol) + sumsqr(ddq4_sol) + sumsqr(ddq5_sol))*dt;

% Animate the gait pattern
P_J = JointPos(l1,l2,l3,l4,l5,q1_sol,q2_sol,q3_sol,q4_sol,q5_sol)';
animation(P_J,dt,D);