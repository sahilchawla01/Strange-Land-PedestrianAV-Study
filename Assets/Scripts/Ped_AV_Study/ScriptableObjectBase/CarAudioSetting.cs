using UnityEngine;

namespace Ped_AV_Study.ScriptableObjectBase
{
    [CreateAssetMenu(fileName = "CarAudioSetting", menuName = "Scriptable Objects/CarAudioSetting")]
    public class CarAudioSetting : ScriptableObject
    {
        public float volume = 1.0f;
        //The time from the start of car animation to play the audio 
        public float timeToPlayAudio = 1.0f;
        public AudioClip audioClipToPlay;
    }
}
