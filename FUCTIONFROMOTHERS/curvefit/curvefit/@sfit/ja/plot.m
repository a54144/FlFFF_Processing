% PLOT  �Ȗʋߎ��I�u�W�F�N�g�̃v���b�g
%
%   PLOT(FO) �́A���݂̎��̔͂��w�肳��Ă���ꍇ�͂��͈̔͂ɁA�w�肳���
%   ���Ȃ��ꍇ�͋ߎ��ɕۑ�����Ă���͈͑S�̂ɋȖʋߎ��I�u�W�F�N�g F0 ��
%   �v���b�g���܂��B
%
%   PLOT(FO, [X, Y], Z) �́AZ �ɑ΂��� X �� Y ���v���b�g���A�v���b�g X �� 
%   Y �͈̔͑S�̂� F0 ���v���b�g���܂��B
%
%   PLOT(FO, [X, Y], Z, 'Exclude', EXCLUDEDATA) �́A�قȂ�F�Ŕr������
%   �f�[�^���v���b�g���܂��BEXCLUDEDATA �͘_���z��ŁAtrue �ُ͈�l��
%   �\�킵�܂��B
%
%   PLOT(FO, ..., 'Style', STYLE) �́A�Ȗʋߎ��I�u�W�F�N�g F0 ���v���b�g����
%   ���@��I�����܂��BSTYLE �́A�ȉ��̕�����̂����ꂩ�ɂȂ�܂��B
%
%       'Surface'   �ȖʂƂ��ċߎ��I�u�W�F�N�g���v���b�g (�f�t�H���g)
%       'PredFunc'  �Ȗʂɑ΂���\�z�͈͂����Ȗ�
%       'PredObs'   �V�K�ϑ��ɑ΂���\�z�͈͂����Ȗ�
%       'Residuals' �c�����v���b�g (�ߎ��� Z=0 �̕��ʂł�)
%       'Contour'   �Ȗʂ̓������}���쐬
%
%   PLOT(FO, ..., 'Level', LEVEL) �́A�v���b�g���Ŏg����M���x��ݒ肵�܂��B
%   LEVEL �� 1 ��菬�������̒l�ŁA�f�t�H���g�� 0.95 (95% �M���x) �ł��B
%   ���̃I�v�V�����́A'PredFunc' �� 'PredObs' �̃v���b�g�X�^�C���ɂ̂ݓK�p����܂��B
%
%   PLOT(FO, ..., 'XLim', XLIM) ��
%   PLOT(FO, ..., 'YLim', YLIM) �́A�v���b�g���Ŏg���鎲�͈̔͂�ݒ肵�܂��B
%   �f�t�H���g�ł́A���͈̔͂̓f�[�^ XY ���瓾���܂��B�f�[�^���^������
%   ���Ȃ��ꍇ�A���͈̔͂͋Ȗʋߎ��I�u�W�F�N�g F0 ���瓾���܂��B
%
%   H = PLOT(FO, ...) �́A�v���b�g���ꂽ�I�u�W�F�N�g�̃n���h����v�f�Ƃ���
%   �x�N�g����Ԃ��܂��B
%
%   H = PLOT(FO, ..., 'Parent', HAXES) �́A���݂̎��ł͂Ȃ��A�n���h�� HAXES 
%   �������ɋߎ��I�u�W�F�N�g F0 ���v���b�g���܂��B����ɁA���͈̔͂� 'XLim' 
%   �܂��� 'YLim' �p�����[�^�Ŏw�肵�Ȃ��ꍇ�A�ߎ���f�[�^����ł͂Ȃ��A
%   �n���h���̎�����͈͂��擾���܂��B
%
%   �Q�l: LINE, SURFACE, CFIT/PLOT.

%   Copyright 2008-2009 The MathWorks, Inc.
