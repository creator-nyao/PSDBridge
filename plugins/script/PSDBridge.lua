-- ���̃t�@�C���� AviUtl �̃e�L�X�g�I�u�W�F�N�g��X�N���v�g����t�B���^��
-- require("PSDBridge") ���������ɓǂݍ��܂��t�@�C��
-- ���̃t�@�C�����ǂݍ��܂��Ƃ������Ƃ͐������t�@�C�����ǂݍ��߂Ă��Ȃ��̂ŁA
-- ��U�L���b�V���𖳌������p�X��ʂ�����ŉ��߂ēǂݍ���
package.loaded["PSDBridge"] = nil
local origpath = package.path
package.path = obj.getinfo("script_path") .. "PSDBridge\\?.lua"
local p = require("PSDBridge")
require("PSDBridge")
package.path = origpath
return p
