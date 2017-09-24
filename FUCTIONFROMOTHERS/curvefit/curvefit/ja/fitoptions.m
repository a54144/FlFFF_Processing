%FITOPTIONS  Fit options �I�u�W�F�N�g�̍쐬/�C��
%
%   F = FITOPTIONS(LIBNAME) �́A���C�u�������f�� LIBNAME �ɑ΂��āA�f�t�H���g�l��
%   �I�v�V�����p�����[�^�Ƃ��Ďg���āAfitoptions �I�u�W�F�N�g F ���쐬���܂��B
%   LIBNAME �̏ڍ׏��́ACFLIBHELP ���Q�Ƃ��Ă��������B
%
%   F = FITOPTIONS(LIBNAME,'PARAM1',VALUE1,'PARAM2',VALUE2,...) �́A�w�肵��
%   �p�����[�^�ŕύX���ꂽ�l���g���ă��C�u�������f�� LIBNAME �ɑ΂���
%   �f�t�H���g�� fitoptions �I�u�W�F�N�g���쐬���܂��B
%
%   F = FITOPTIONS('METHOD',VALUE) �́AVALUE �Ŏw�肵�����@���g���āA
%   �f�t�H���g�� fitoptions �I�u�W�F�N�g���쐬���܂��BVALUE �őI���\�Ȓl�́A
%   �ȉ��̂Ƃ���ł��B
%
%      NearestInterpolant     - �ŋߖT���
%      LinearInterpolant      - ���`���
%      PchipInterpolant       - �敪�I 3 ���G���~�[�g���
%      CubicSplineInterpolant - 3 ���X�v���C�����
%      BiharmonicInterpolant  - �d���a�Ȗʕ��
%      SmoothingSpline        - �������X�v���C��
%      LowessFit              - Lowess (�Ǐ���A������) �ߎ�
%      LinearLeastSquares     - ���`�ŏ����
%      NonlinearLeastSquares  - ����`�ŏ����
%
%   VALUE �ւ̓��͂́A���ׂĂ̕�������͂���K�v�͂Ȃ��A�ŗL�Ɏ��ʂł���
%   �������ŏ\���ł��B�܂��A�啶���A�������̋�ʂ͂���܂���B
%
%   F = FITOPTIONS('METHOD',VALUE1,'PARAM2',VALUE2,...) �́A�w�肵���l��
%   �ύX�������O�t���p�����[�^���g���� VALUE1 �Ŏw�肵�����\�b�h�ɑ΂���
%   �f�t�H���g�� fitoptions �I�u�W�F�N�g���쐬���܂��B
%
%   F = FITOPTIONS(OLDF,NEWF) �́A������ fitoptions �I�u�W�F�N�g OLDF ��
%   �V���� fitoptions �I�u�W�F�N�g NEWF ��g�ݍ��킹�܂��BOLDF �� NEWF ��
%   ���� 'Method' �̏ꍇ�A��łȂ��l������ NEWF ���̂������̃p�����[�^�́A
%   OLDF ���̑Ή�����Â��p�����[�^�����������܂��BOLDF �� NEWF ���قȂ� 
%   'Method' �����ꍇ�AF �́AOLDF �Ɠ��� Method �������ANEWF �� 'Normalize', 
%   'Exclude', 'Weights' �t�B�[���h�� OLDF �̂��̂Ƒウ�Ďg�p���܂��B
%
%   F = FITOPTIONS(OLDF,'PARAM1',VALUE1,'PARAM2',VALUE2,...) �́Afitoptions 
%   �I�u�W�F�N�g OLDF �ɑ΂��āA�w�肵���p�����[�^�ƒl�ŏ������������̂ŁA
%   �V���� fitoptions �I�u�W�F�N�g���쐬���܂��B
%
%   F = FITOPTIONS �́A���ׂẴt�B�[���h���f�t�H���g�l�ɐݒ肳��AMethod 
%   �p�����[�^���A'None' �ł��� fitoptions �I�u�W�F�N�g F ���쐬���܂��B
%
%   ���ׂĂ� FITOPTIONS �I�u�W�F�N�g�ɂ́A�ȉ��̃p�����[�^������܂��B
%
%      Normalize - �f�[�^�̒��S���ړ�������A�X�P�[�����O���邩�ۂ���ݒ�
%                   [{'off'} | 'on']
%      Exclude   - �f�[�^�Ɠ��������̔r���x�N�g��
%                  [{[]} | �r�������v�f���� 1 �ɐݒ肵���_���x�N�g��]
%      Weights   - �f�[�^�Ɠ��������̏d�݃x�N�g��
%                  [{[]} | ���̗v�f�����x�N�g��]
%      Method    - FIT �Ŏg�p���郁�\�b�h
%
%   Method �l�ɂ���ẮAfitoptions �I�u�W�F�N�g�͑��̃p�����[�^�������Ƃ�
%   �ł��܂��B
%
%   Method ���ANearestInterpolant, LinearInterpolant, PchipInterpolant, 
%   CubicSplineInterpolant, BiharmonicInterpolant �̂����ꂩ�̏ꍇ�A
%   �ǉ��p�����[�^�͂���܂���B
%
%   Method �� SmoothingSpline �̏ꍇ�A�ȉ��̒ǉ��p�����[�^������܂��B
%      SmoothingParam - �������p�����[�^ [{NaN} | [0,1] �̊Ԃ̒l]
%                       NaN �́AFIT �̊ԁA�v�Z����邱�Ƃ��Ӗ����܂��B
%
%   Method �� LowessFit �̏ꍇ�A�ȉ��̒ǉ��p�����[�^������܂��B
%      Span      - �Ǐ���A�Ŏg�p���邽�߂̃f�[�^�_�̊���
%                  [[0,1] | {0.25} �̃X�J��]
%
%   Method �� LinearLeastSquares �̏ꍇ�A�ȉ��̒ǉ��p�����[�^������܂��B
%
%      Robust    - ���o�X�g�ȍŏ����ߎ���@���w��
%                  [{'off'} | 'on' | 'LAR' | 'Bisquare']
%      Lower     - �ߎ�����W���ɓK�p���鉺���p�̃x�N�g��
%                  [{[]} | �W���̐��𒷂��Ƃ���x�N�g��]
%      Upper     - �ߎ�����W���ɓK�p�������p�̃x�N�g��
%                  [{[]} | �W���̐��𒷂��Ƃ���x�N�g��]
%
%  Method �� NonlinearLeastSquares �̏ꍇ�A�ȉ��̒ǉ��p�����[�^������܂��B
%
%     Robust        - ���o�X�g�Ȕ���`�ŏ����ߎ���@���w�� 
%                     [{'off'} | 'on' | 'LAR' | 'Bisquare']
%     Lower         - �ߎ�����W���ɓK�p���鉺���p�̃x�N�g��
%                     [{[]} | �W���̐��𒷂��Ƃ���x�N�g��]
%     Upper         - �ߎ�����W���ɓK�p���鋛�E���p�̃x�N�g��
%                     [{[]} | �W���̐��𒷂��Ƃ���x�N�g��]
%     StartPoint    - FIT ���̊J�n�_��v�f�Ƃ���x�N�g��
%                     [{[]} | �W���̐��𒷂��Ƃ���x�N�g��]
%     Algorithm     - FIT �Ɏg�p����A���S���Y��
%                     [{'Levenberg-Marquardt'} | 'Gauss-Newton' | 'Trust-Region']
%     DiffMaxChange - �L�������̌��z�ɑ΂���W���̍ő�ω��� 
%                     [���̃X�J�� | {1e-1}]
%     DiffMinChange - �L�������̌��z�ɑ΂���W���̍ŏ��ω��� 
%                     [���̃X�J�� | {1e-8}]
%     Display       - �\�����x�� ['off' | 'iter' | {'notify'} | 'final']
%     MaxFunEvals   - �֐� (���f��) �]���̍ő勖�e��
%                     [���̐���]
%     MaxIter       - �\�ȍő�J��Ԃ��� [ ���̐��� ]
%     TolFun        - �֐� (���f��) �l�̏I�����e�덷
%                     [ ���̃X�J��  | {1e-6} ]
%     TolX          - �W���̏I�����e�덷
%                     [ ���̃X�J��  | {1e-6} ]
%
%  �p�����[�^���ŗL�Ɏ��ʂ��铪�����Ɠ��͂��邾���Őݒ肷�邱�Ƃ��ł��܂��B
%  �p�����[�^���̑啶���Ə������̋�ʂ͖�������܂��B
%
%  �Q�l FITTYPE, CFLIBHELP.


%   Copyright 2001-2009 The MathWorks, Inc.
