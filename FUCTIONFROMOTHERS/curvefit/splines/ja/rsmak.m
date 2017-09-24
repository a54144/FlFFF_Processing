% RSMAK   rB-�^�̗L���X�v���C���̓���
%
% RSMAK(KNOTS,COEFS) �́A���͂ɂ���Ďw�肳�ꂽ�L���X�v���C����
% rB-�^���o�͂��܂��B
%
% ����͗L���X�v���C���� B-�^�ƂƂ��ĔF������邱�ƁA���Ȃ킿�A���ꂪ
% �X�v���C���̍Ō�̗v�f�ɂ���Ď�����A���q���c��̗v�f�ɂ���Ď������
% ���Ƃ������A������ SPMAK(KNOTS,COEFS) �̏o�͂ƂȂ�܂��B����ɑΉ����āA
% ���̃^�[�Q�b�g�̎����́ASPMAK(KNOTS,COEFS) �̏o�͂̎������� 1 ��
% �������Ȃ�܂��B
%
% ���ɁA���͂̌W���́A���� d>0 �ɑ΂���(d+1)�v�f�̃x�N�g���l�łȂ����
% �Ȃ炸�AN�����̔z��l�Ƃ��Ă͂����܂���B
%
% �Ⴆ�΁Aspmak([-5 -5 -5 5 5 5],[26 -24 26]) �́A��� [-5 .. 5] ��
% ������ t |-> t^2+1 ��B-�^��^���܂����Aspmak([-5 -5 -5 5 5 5], [1 1 1]) 
% �́A�萔�֐� 1 �� B-�^��^���܂��B���������āA�R�}���h
%
%      runge = rsmak([-5 -5 -5 5 5 5],[1 1 1; 26 -24 26]);
%
% �́A���Ԋu�̈ʒu�ł̑�������ԂɊւ��� Runge �̗�ŗL���ȗL���֐�
% t |-> 1/(t^2+1) �ɑ΂����� [-5 .. 5] �ł� rB-�^��^���܂��B
%
% RSMAK(KNOTS,COEFS,SIZEC) �́ACOEFS ����ɑ����v�f��1�̎��������Ƃ���
% �g�p����܂��B���̏ꍇ�ASIZEC �� COEFS �̈Ӑ}�����傫����^����x�N
% �g���łȂ���΂Ȃ�܂���B���� SIZEC(1) �́A���ۂ� COEFS �̍ŏ��̎�����
% �Ȃ���΂Ȃ�܂���B���������āASIZEC(1)-1 �́A�^�[�Q�b�g�̎����ł��B
%   
% c(:,i) �� NURBS �ɂ����鐧��_�A�܂��� w(i) ��Ή����邨���݂Ƃ��� 
% rB-�^�̓T�^�I�ȌW���̌`���� [w(i)*c(:,i);w(i)] �ł���Ƃ����Ӗ���
% rB-�^ �� NURBS �Ɠ����Ƃ����܂��B
%
% RSMAK(OBJECT, ... ) �́A������ OBJECT �Ŏw�肳�ꂽ����̊􉽊w�I�Ȍ`���
% �o�͂��܂��B�Ⴆ�΁A
%
% RSMAK('circle',RADIUS,CENTER) �́A���a RADIUS (�f�t�H���g�l 1) �ƒ��S 
% CENTER (�f�t�H���g�l (0,0)) ���琬��~���L�q���� 2 ���̗L���X�v���C����
% �^���܂��B
%
% RSMAK('arc',RADIUS,CENTER,[ALPHA BETA]) �́A���a RADIUS (�f�t�H���g�l 1) 
% �ƒ��S CENTER (�f�t�H���g�l (0,0)) �����~�̌ʁAALPHA ���� BETA 
% (�f�t�H���g�l -pi/2 ���� pi/2) ���琬�� 2 ���̗L���X�v���C����^���܂��B
%
% RSMAK('cone',RADIUS,HEIGHT) �́A��[�� (0,0,0) �� z-���W��ɒ��S����
% �����a RADIUS (�f�t�H���g�l 1) �Ɣ����̍��� HEIGHT (�f�t�H���g�l 1) ��
% �Ώ̂ȉ~�����琬�� 2 ���̗L���X�v���C����^���܂��B
%
% RSMAK('cylinder',RADIUS,HEIGHT) �́Az-���W��ɒ��S���������a RADIUS 
% (�f�t�H���g�l 1) �ƍ��� HEIGHT (�f�t�H���g�l 1) �̉~�����琬�� 2 ����
% �L���X�v���C����^���܂��B
%
% RSMAK('torus',RADIUS,RATIO) �́A���S�� (0,0,0) �ŁA(x,y) ���ʓ��Ɏ�v�~��
% ���A�O���̔��a RADIUS (�f�t�H���g�l 1) �Ɠ����̔��a RADIUS*RATIO 
% (�f�t�H���g�l : RATIO = 1/3) �̉~�ʂ��琬�� 2 ���̗L���X�v���C����
% �^���܂��B
%
% RSMAK('southcap',RADIUS,CENTER) �́A���a RADIUS (�f�t�H���g�l 1) ��
% ���S CENTER (�f�t�H���g�l (0,0,0)) �������̓쑤�� 6 ���� 1 ��^���܂��B
%
% fncmb(rs,transf) ��p����� RSMAK �̌��ʓ�����􉽊w�I�I�u�W�F�N�g��
% �΂� transf �Ŏw�肳�ꂽ�A�t�B���ϊ����s�Ȃ����Ƃ��ł��܂��B
% �ȉ��̗�ł́A'southcap' ���g�A���̉�]�̂����� 2 �A����т��̋��f��
% ����ė^�����鋅�� 2/3 �̃v���b�g�𐶐����܂��B
%
%      southcap = rsmak('southcap');
%      xpcap = fncmb(southcap,[0 0 -1;0 1 0;1 0 0]);
%      ypcap = fncmb(xpcap,[0 -1 0; 1 0 0; 0 0 1]);
%      northcap = fncmb(southcap,-1);
%      fnplt(southcap), hold on, fnplt(xpcap), fnplt(ypcap), fnplt(northcap)
%      axis equal, shading interp, view(-115,10), axis off, hold off
%
% �Q�l RSBRK, RPMAK, PPMAK, SPMAK, FNBRK.


%   Copyright 1999-2008 The MathWorks, Inc.
