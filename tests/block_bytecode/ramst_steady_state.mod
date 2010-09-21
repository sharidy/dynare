// Tests steady_state, in the static and dynamic bytecode file

var c k w;
varexo x;

parameters alph gam delt bet aa c_steady_state;
alph=0.5;
gam=0.5;
delt=0.02;
bet=0.05;
aa=0.5;

model(bytecode, block);
c + k - aa*x*k(-1)^alph - (1-delt)*k(-1);
c^(-gam) - (1+bet)^(-1)*(aa*alph*x(+1)*k^(alph-1) + 1 - delt)*c(+1)^(-gam);
w = steady_state(k);
end;

initval;
x = 1;
k = ((delt+bet)/(1.0*aa*alph))^(1/(alph-1));
c = aa*k^alph-delt*k;
w = 0;
end;

steady(solve_algo=5);

//check;

shocks;
var x;
periods 1;
values 1.2;
end;

simul(periods=20, stack_solve_algo=5);

if(abs(oo_.steady_state(2) - oo_.steady_state(3)) > 1e-10)
   error('Test failed in the static bytecode file for steady_state')
end

if(abs(oo_.steady_state(2) - oo_.endo_simul(3,2)) > 1e-10)
   error('Test failed in the dynamic bytecode file for steady_state')
end