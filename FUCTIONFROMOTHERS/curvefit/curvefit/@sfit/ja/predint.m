%PREDINT  �ߎ����ʃI�u�W�F�N�g�܂��͐V�K�ϑ��_�ɑ΂���\�����
%
%   CI = PREDINT(FITRESULT,[X,Y],LEVEL) �́A�w�肵�� X, Y �̒l�ŁA�V���� Z ��
%   �l�ɑ΂���\����Ԃ�Ԃ��܂��BLEVEL �́A�M���x�ŁA�f�t�H���g�l�� 0.95 �ł��B
%
%   CI = PREDINT(FITRESULT,[X,Y],LEVEL,'INTOPT','SIMOPT') �́A�v�Z�����Ԃ�
%   �^�C�v���w�肵�܂��B'INTOPT' �́A�V�����ϑ��ɑ΂���͈͂��v�Z����ꍇ�� 
%   'observation' (�f�t�H���g)�AX, Y �Ōv�Z���ꂽ�Ȗʂɑ΂���͈͂��v�Z����
%   �ꍇ�� 'functional' �̂����ꂩ��ݒ肷�邱�Ƃ��ł��܂��B
%   'SIMOPT' �́A'on' �̏ꍇ�͓����̐M����Ԃ��v�Z���A'off' �̏ꍇ��
%   �񓯎���Ԃ��v�Z���܂�
%
%   'INTOPT' �� 'functional' �̏ꍇ�A���͈̔͂͋Ȑ��̐���ɂ����ĕs�m������
%   ���肵�܂��B�܂��A'INTOPT' �� 'observation' �̏ꍇ�A���͈̔͂͐V���� 
%   Z �l (�Ȑ��{�����_���m�C�Y) �̗\���ɂ�����s�m������\�킷���߂ɂ��
%   �L���Ȃ�܂��B
%
%   �M���x�� 95% �ŁA'INTOPT' �� 'functional' �Ɖ��肵�܂��B'SIMOPT' �� 
%   'off' (�f�t�H���g) �̏ꍇ�A�^�̋Ȗʂ��M����Ԃ̊Ԃɓ��� 95% �̐M���x������ 
%   1 �̂��炩���ߒ�`���ꂽ X, Y �l���^�����܂��B'SIMOPT' �� 'on' �̏ꍇ�A
%   �ȖʑS�̂� (���ׂĂ� X, Y �l��) �͈͓��ɂ��� 95% �̐M����Ԃ������܂��B
%
%   [CI, YI] = PREDINT( ... ) �́A����ɗ\�� YI ���Ԃ��܂��B
%
%   �Q�l: SFIT, SFIT/FEVAL.

%   Copyright 2001-2009 The MathWorks, Inc.
