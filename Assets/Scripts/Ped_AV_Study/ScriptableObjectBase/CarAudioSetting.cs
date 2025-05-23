using UnityEngine;

namespace Ped_AV_Study.ScriptableObjectBase
{
    [CreateAssetMenu(fileName = "CarAudioSetting", menuName = "Scriptable Objects/CarAudioSetting")]
    public class CarAudioSetting : ScriptableObject
    {
        public float volume = 1.0f;
        //The time from the start of car animation to play the audio 
        public float timeToPlayAudio = 1.0f;
        //Should the audio played be 3D or not (2D). 
        public bool bDynamicAudio = false;
        public bool bLoopAudio = false;
        public AudioClip audioClipToPlay;
    }
}
