% Curve Fitting Toolbox -- Spline Functions 
%
%
% GUI
%   splinetool - �����̃X�v���C���ߎ��@ (GUI)
%   bspligui   - �ߓ_�̊֐��Ƃ��Ă� B-�X�v���C�� (GUI)
%
% �X�v���C���̍쐬
%                         
%   csape    - �[���������� 3 ���X�v���C�����
%   csapi    - 3 ���X�v���C�����
%   csaps    - 3 ���������X�v���C��
%   cscvn    - 'natural' �܂��� 'periodic' 3 ���X�v���C���Ȑ�
%   getcurve - 3 ���X�v���C���Ȑ��̑Θb�I�ȍ쐬
%   ppmak    - pp-�^�X�v���C���̓���
%
%   spap2    - �ŏ����X�v���C���ߎ�
%   spapi    - �X�v���C�����
%   spaps    - �������X�v���C��
%   spcrv    - �ϓ������X�v���C���Ȑ�
%   spmak    - B-�^�X�v���C���̓���
%
%   rpmak    - rp-�^�L���X�v���C���̓���
%   rscvn    - rB-�^�敪�~�ʋȐ��̕��
%   rsmak    - rB-�^�L���X�v���C���̓���
%
%   stmak    - st-�^�X�v���C���̓���
%   tpaps    - ���������X�v���C��
%
% �X�v���C���̑��� (B-�^, pp-�^, rB-�^, st-�^, ...�̔C�ӂ̌^�A
%                          1 �ϐ��܂��͑��ϐ�)
%   fnbrk    - �^�̖��O�ƍ\���v�f
%   fnchg    - �^�̍\���v�f�̕ύX
%   fncmb    - �֐��̎Z�p
%   fnder    - �֐��̔���
%   fndir    - �֐��̕�������
%   fnint    - �֐��̐ϕ�
%   fnjmp    - �֐��̔�сA���Ȃ킿�Af(x+) - f(x-) 
%   fnmin    - �^����ꂽ��Ԃł̊֐��̍ŏ��l
%   fnplt    - �֐��̃v���b�g
%   fnrfn    - �ǉ��_���^�̋�Ԃɑ}��
%   fntlr    - �e�C���[�W���A���邢�́A������
%   fnval    - �֐��̕]��
%   fnxtr    - �֐��̊O�}
%   fnzeros  - �^����ꂽ��Ԃł̊֐��̗�_
%   fn2fm    - �ݒ肳�ꂽ�^�ւ̕ϊ�
%
% �ߓ_�A�u���[�N�|�C���g�A�T�C�g�̎�z
%   aptknt   - �K�؂Ȑߓ_��
%   augknt   - �ߓ_��̒ǉ�
%   aveknt   - �ߓ_�̕���
%   brk2knt  - ���d�x�����u���[�N�|�C���g��ߓ_�ɕϊ�
%   chbpnt   - �K�؂ȃf�[�^�ʒu�AChebyshev-Demko �_
%   knt2brk  - �ߓ_����u���[�N�|�C���g�Ƒ��d�x�ɕϊ�
%   knt2mlt  - �ߓ_�̑��d�x
%   newknt   - �V�����u���[�N�|�C���g�̕��z
%   optknt   - ��Ԃɑ΂��� "�œK��" �ߓ_�̕��z
%   sorted   - ���b�V���T�C�g�ɑ΂���T�C�g�̈ʒu�t��
%
% �X�v���C���쐬�c�[��
%   spcol    - B-�X�v���C���I�_�s��
%   stcol    - �_�݂���ϊ��I�_�s��
%   slvblk   - �قڃu���b�N�Ίp�Ȑ��`�V�X�e���̉�
%   bkbrk    - �قڃu���b�N�Ίp�ȍs��̈ꕔ
%
% �X�v���C���ϊ��c�[��
%   splpp    - �Ǐ��I�� B-�W�����獶�̃e�C���[�W���ւ̕ϊ�
%   sprpp    - �Ǐ��I�� B-�W������E�̃e�C���[�W���ւ̕ϊ�
%
% �֐��ƃf�[�^
%   franke   - Franke �� 2 �ϐ��e�X�g�֐�
%   subplus  - ������
%   titanium - (�`�^���Ɋւ���) �e�X�g�f�[�^
%
% �X�v���C���ƃc�[���{�b�N�X�̏��
%   bspline  - B-�X�v���C���Ƃ��̑������̍\���v�f���v���b�g
%   spterms  - Spline �̗p��̐���

%   Copyright 1987-2013 The MathWorks, Inc.
%   Generated from Contents.m_template revision 1.1.6.4  $Date: 2012/08/20 23:59:29 $
