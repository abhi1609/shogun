C=1;
order=20;
order_com=5;
max_mismatch=0;
len=200;
shift=10;
num=1000;
num_test=2000;
cache=10;

acgt='ACGT';
rand('state',1);
traindat=acgt(ceil(4*rand(len,num)));
trainlab=[-ones(1,num/2),ones(1,num/2)];

testdat=acgt(ceil(4*rand(len,num_test)));
testlab=[-ones(1,num/2),ones(1,num_test/2)];
x=ceil(linspace(1,shift,len));
shifts = sprintf( '%i ', x(end:-1:1) );

sg('send_command', 'loglevel ALL');
sg('send_command','clean_features TRAIN');
sg('send_command','clean_features TEST');
sg('send_command','threads 4');
sg('send_command','clean_kernels');
sg('send_command', 'use_linadd 1' );
sg('send_command', 'use_batch_computation 1');

sg('set_features', 'TRAIN', traindat, 'DNA');
sg('set_labels', 'TRAIN', trainlab);

sg('set_features', 'TEST', testdat, 'DNA');
sg('set_labels', 'TEST', testlab);
%
sg('send_command', sprintf( 'set_kernel WEIGHTEDDEGREEPOS2 CHAR 10 %i %i %i %s', order, max_mismatch, len, shifts ) );
sg('send_command', 'set_kernel_optimization_type FASTBUTMEMHUNGRY' );
sg('send_command', 'init_kernel TRAIN');
kt=sg('get_kernel_matrix');
sg('send_command', 'new_svm LIGHT');
sg('send_command', sprintf('c %f',C));
tic; sg('send_command', 'svm_train'); t=toc
[b, alphas]=sg('get_svm');

tic;
sg('send_command', 'init_kernel TEST');
outopt=sg('svm_classify');
tout=toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
sg('send_command', 'loglevel ALL');
sg('send_command','clean_features TRAIN');
sg('send_command','clean_features TEST');
sg('send_command','clean_kernels');
sg('send_command','threads 4');
sg('send_command', 'use_linadd 0' );
sg('send_command', 'use_batch_computation 0');

sg('set_features', 'TRAIN', traindat, 'DNA');
sg('set_labels', 'TRAIN', trainlab);
%
sg('set_features', 'TEST', testdat, 'DNA');
sg('set_labels', 'TEST', testlab);
%
sg('send_command', sprintf( 'set_kernel WEIGHTEDDEGREEPOS2 CHAR 10 %i %i %i %s', order, max_mismatch, len, shifts ) );
sg('send_command', 'set_kernel_optimization_type FASTBUTMEMHUNGRY' );
sg('send_command', 'init_kernel TRAIN');
ktref=sg('get_kernel_matrix');
sg('send_command', 'new_svm LIGHT');
sg('send_command', sprintf('c %f',C));
tic; sg('send_command', 'svm_train'); tref=toc
[bref, alphasref]=sg('get_svm');
tic;
sg('send_command', 'init_kernel_optimization');
sg('send_command', 'init_kernel TEST');
outoptref=sg('svm_classify');
toutref=toc

outopt(1:10)
outoptref(1:10)
max(abs(outopt-outoptref))

t
tref
tout
toutref
b
bref
