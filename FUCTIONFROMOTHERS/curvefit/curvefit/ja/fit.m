%FIT  �Ȑ��܂��͋Ȗʂ̃f�[�^�ߎ�
%
%   FO = FIT(X, Y, FT) �́A�f�[�^ X, Y �ւ̋ߎ��^�C�v FT �Ŏw�肳�ꂽ
%   �ߎ����f���̌��ʂ��J�v�Z�������� fit �I�u�W�F�N�g�ł��B
%
%   -- X �́A1 �� (�Ȑ��ߎ�) �܂��� 2 �� (�Ȗʋߎ�) �̍s��ł��B�Ȗʋߎ���
%   �ꍇ�A����̂��ׂẴf�[�^���ȉ��̂悤�Ɏw�肷�邱�Ƃ��ł��܂��B
%
%       fo = fit( [x, y], z, ft )
%
%   -- Y �� X �Ɠ����s��������x�N�g���ł��B
%
%   -- FT �́A�ߎ����郂�f�����w�肷�镶����A�܂��� FITTYPE �I�u�W�F�N�g�ł��B
%
%   FT ��������̏ꍇ�A�ȉ��̂悤�ɂȂ�܂��B
%
%                FITTYPE                �ڍ�
%   Splines: (�Ȑ��̂�)
%                'smoothingspline'      �������X�v���C��
%                'cubicspline'          3 �� (���) �X�v���C��
%   ���:
%                'linearinterp'         ���`���
%                'nearestinterp'        �ŋߖT���
%                'splineinterp'         3 ���X�v���C�����
%                'pchipinterp'          �^��ۑ����� (pchip) ��� (�Ȑ��̂�)
%                'biharmonicinterp'     �d���a (MATLAB 4 �� griddata) ��� (�Ȗʂ̂�)
%   �Ǐ���A������ (�Ȗʂ̂�)
%                'lowess'               Lowess (���`�ߎ�) ���f��
%                'loess'                Loess (2 ���ߎ�) ���f��
%
%   �܂��́ACFLIBHELP �ɋL�q����郉�C�u�������f���̖��O��ݒ�ł��܂� 
%   (���C�u�������f���̖��O��ڍׂɂ��ẮACFLIBHELP �Ɠ��͂��Ă�������)�B
%
%   FO = FIT(X, Y, FT) �́AFT �� FITTYPE �I�u�W�F�N�g�ŁAFT ���̏��ɏ]����
%   �f�[�^ X �� Y ���ߎ�����ꍇ�A�ߎ��������f�� F0 ��Ԃ��܂��B
%   �J�X�^�����f���́AFITTYPE �֐����g���č쐬����܂��B
%
%   FO = FIT(X, Y, FT,...,PROP1,VAL1,PROP2,VAL2,...) �́A�v���p�e�B���ƒl�A
%   PROP1, VAL1 ���Ŏw�肵�����ƃA���S���Y���̃I�v�V�������g���āA�f�[�^ X �� 
%   Y ���ߎ����A�ߎ��������f�� FO ��Ԃ��܂��B
%   FITOPTIONS �v���p�e�B�ƃf�t�H���g�l�ɂ��ẮAFITOPTIONS(FITTYPE) ��
%   ���͂��Ă��������B
%   ���Ƃ��΁A
%
%      fitoptions( 'cubicspline' )
%      fitoptions( 'exp2' )
%
%   FO = FIT(X, Y, FT, ..., 'Weight', W) �́A�d�ݕt�������ߎ����d�� W �ōs��
%   ���Ƃ������Ă��܂��BW �� Y �Ɠ����T�C�Y�̃x�N�g���łȂ���΂Ȃ�܂���B
%
%   FO = FIT(X, Y, FT, OPTIONS) �́AFITOPTIONS �I�u�W�F�N�g OPTIONS �Ɏw��
%   ���ꂽ���ƃA���S���Y���̃I�v�V�������g���ăf�[�^ X �� Y ���ߎ����܂��B
%   ����́A�v���p�e�B�̖��O�ƒl��g�Őݒ肷��ʂ̕\�����@�ł��B
%   OPTIONS �I�u�W�F�N�g�̍쐬�Ɋւ���w���v�́AFITOPTIONS ���Q�Ƃ��Ă��������B
%
%   FO = FIT(X, Y, FT, ..., 'problem', VALUES) �́AVALUES �� problem �Ɉˑ�����
%   �萔�ɑ�����܂��BVALUES �́Aproblem �Ɉˑ������萔�ɕt����̗v�f������
%   �Z���z��ł��Bproblem �Ɉˑ������萔�Ɋւ�����́AFITTYPE ���Q�Ƃ��Ă��������B
%
%   [FO, G] = FIT(X, Y, ...) �́A�^����ꂽ���͂ɑ΂���K�؂ȓK���x���\���� 
%   G �ɕԂ��܂��BG �͈ȉ��̃t�B�[���h���܂݂܂��B
%       -- SSE         �덷�ɂ����a
%       -- R2          ����W���܂��� R^2
%       -- adjustedR2  ���R�x��������W��
%       -- stdError    �ߎ��W���덷�܂��͓�敽�ϕ������덷
%
%   [FO, G, O] = FIT(X, Y, ...) �́A�^����ꂽ���͂ɑ΂��ēK�؂ȏo�͒l������
%   �\���� O ��Ԃ��܂��B���Ƃ��΁A����`�ߎ����ɑ΂��āA�J��Ԃ��񐔁A
%   ���f���̌v�Z�񐔁A���������� exitflag �A�c���A���R�r�A���� O �ɕԂ��܂��B
%
%   ��:
%      [curve, goodness] = fit( x, y, 'pchipinterp' );
%   �́Ax �� y �� 3 ����ԃX�v���C���ŋߎ����܂��B
%
%      curve = fit( x, y, 'exp1', 'Startpoint', p0 );
%   �́A�J�n�_�� p0 �Ƃ���w�����f�� (�P�ꍀ�̎w��) �� �Ȑ��ߎ����C�u������
%   �� 1 �Ԗڂ̕�������p���ċߎ����܂��B
%
%      sf = fit( [x, y], z, 'poly23', 'Robust', 'LAR' );
%   �́A�ŏ���Ύc���̃��o�X�g (LAR) �@���g���āAx �Ɏ��� 2�Ay �Ɏ��� 3 ��
%   �������Ȗʂ��ߎ����܂��B
%
%   ���l:
%   �L�����̃��C�u�����f���A����сA���ׂẴJ�X�^���Ȕ���`���f���ł́A
%   �W���ɑ΂���f�t�H���g�̏����l�́A��� (0,1) �����l�Ƀ����_���Ȓl��
%   �I������܂��B���ʂƂ��āA�����f�[�^�ƃ��f�����g���������̋ߎ��́A
%   �قȂ�ߎ��W���ɂȂ�\��������܂��B�W���ɑ΂��鏉���l�� FITOPTIONS 
%   �\���́A�܂��́AStartPoint �v���p�e�B�ɑ΂���x�N�g�����g���Ďw�肷��
%   ���Ƃł��̉\����������邱�Ƃ��ł��܂��B
%
%   �Q�l CFLIBHELP, FITTYPE, FITOPTIONS.


%   Copyright 1999-2009 The MathWorks, Inc.
