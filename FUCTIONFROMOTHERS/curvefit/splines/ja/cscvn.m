% CSCVN   'natural' �܂��� 'periodic' 3 ���X�v���C���Ȑ�
%
%   CS  = CSCVN(POINTS)
%
% �́Ai=1,2,..., �ƂȂ�p�����[�^�l t(i) �ŗ^����ꂽ�_ POINTS(:,i) ��
% ��Ԃ���p�����g���b�N�� 'natural' 3 ���X�v���C�����o�͂��܂��B
% t(i) �́AEugene Lee's centripetal scheme�ɂ���āA���Ȃ킿�A������
% ���������ݐς��ꂽ���̂Ƃ��đI������܂��B
%
% �ŏ��ƍŌ�̓_����v���A��d�_���Ȃ��Ƃ��A�p�����g���b�N�Ȏ����I�L���[
% �r�b�N�X�v���C��������ɍ쐬����܂��B�������A��d�_������Ɗp������
% ���ʂɂȂ�܂��B
%
% ���Ƃ���,
%
%      fnplt(cscvn( [1 0 -1    0 1;0 1 0   -1 0] ))
%
% �́A(�����I�ȋ��E�����̂���)�W���̕H�`��4���_��ʂ�(�~�`��)�Ȑ���\��
% ���܂��B����A
%
%      fnplt(cscvn( [1 0 -1 -1 0 1;0 1 0 0 -1 0] ))
%
% �́A�Ȑ��̒[�_�Ɠ����悤�ɓ�d�_�̕����Ɋp�������Ƃ������܂��B
%
% �Q�l CSAPI, CSAPE, GETCURVE, SPCRVDEM, SPLINE.


%   Copyright 1987-2008 The MathWorks, Inc.
