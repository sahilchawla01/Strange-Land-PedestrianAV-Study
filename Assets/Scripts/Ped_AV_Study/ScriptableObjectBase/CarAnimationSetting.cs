using System.Collections.Generic;
using UnityEngine;

namespace Ped_AV_Study.ScriptableObjectBase
{
    [CreateAssetMenu(fileName = "CarAnimationSetting", menuName = "Scriptable Objects/CarAnimationSetting")]
    public class CarAnimationSetting : ScriptableObject
    {
        // Distance from the current position to start the animation
        public float startDistance = 100.0f;
        // Total time for the animation
        public float animationTime = 2.0f;
        // The curve the speed of the car should follow
        public AnimationCurve easeCurve = AnimationCurve.EaseInOut(0, 0, 1, 1); 
        public List<CarAudioSetting> carAudioSettings = new List<CarAudioSetting>();
    }
}
