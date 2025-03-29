using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace Ped_AV_Study.ScriptableObjectBase
{
    [CreateAssetMenu(fileName = "CarAnimationSetting", menuName = "Scriptable Objects/CarAnimationSetting")]
    public class CarAnimationSetting : ScriptableObject
    {
        // Distance from the current position to start the animation
        [Tooltip("Distance from the current position to start the animation from")] 
        public UInt16 totalAnimationDistance = 100;
        //If greater than 0, stop animation 'x' distance from final position
        [Tooltip("If greater than 0, stop car animation 'x' distance from final position")]
        public Int16 earlyStoppingDistance = 20;
        // Total time for the animation
        public float animationTime = 2.0f;
        // The curve the speed of the car should follow
        public AnimationCurve easeCurve = AnimationCurve.EaseInOut(0, 0, 1, 1); 
        public List<CarAudioSetting> carAudioSettings = new List<CarAudioSetting>();
    }
}
