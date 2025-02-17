using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "CarAnimationSetting", menuName = "Scriptable Objects/CarAnimationSetting")]
public class CarAnimationSetting : ScriptableObject
{
    // Distance from the final position to start the animation
    public float startDistance = 100.0f;
    // Total time for the animation
    public float animationTime = 2.0f;
    public List<CarAudioSetting> carAudioSettings = new List<CarAudioSetting>();
}
