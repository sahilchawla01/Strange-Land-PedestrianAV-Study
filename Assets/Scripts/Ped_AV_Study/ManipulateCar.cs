using System.Collections;
using System.Collections.Generic;
using Ped_AV_Study.ScriptableObjectBase;
using UnityEngine;

namespace Ped_AV_Study
{
    public class ManipulateCar : MonoBehaviour
    {
        public AnimationCurve easeCurve = AnimationCurve.EaseInOut(0, 0, 1, 1); // Easing curve
        public CarAnimationSetting initAnimationSetting;
        public List<CarAnimationSetting> carAnimations = new List<CarAnimationSetting>();
      
        // -- COMPONENTS --
        private List<AudioSource> m_audioSources = new List<AudioSource>();
        private CarAnimationSetting m_currentAnimationSetting;
      
        // -- MISCELLANEOUS -- 
        private Vector3 m_finalPosition;
        private Vector3 m_startPosition;
        private Quaternion m_startRotation;
        private float m_elapsedTime = 0f;
        
        private bool bPlayAnimation = false;
        
        // -- COROUTINES -
        List<IEnumerator> m_audioCueCoroutines = new List<IEnumerator>();
        void Start()
        {
            // Store the final position and rotation
            m_finalPosition = transform.position;
            m_startRotation = transform.rotation;
          
            //Set animation setting before playing the car animation
            SetAnimationSettings(initAnimationSetting);
            
            StartAnimation();
        }

        public void SetAnimationSettings(CarAnimationSetting animationSetting)
        {
            m_currentAnimationSetting = animationSetting;
          
            // Calculate the start position by moving in the opposite direction of the forward vector
            m_startPosition = m_finalPosition - transform.forward * m_currentAnimationSetting.startDistance;
          
            // Set the initial position of the object to the start position
            transform.position = m_startPosition;
        }

      
        public void StartAnimation()
        {
            if (!m_currentAnimationSetting)
            {
                Debug.LogError("MANIPULATECAR.cs: No animation setting when StartAnimation was called");
                return;
            }
            
            //According to the number of audio cues, create audio source components
            SetupAudioSourceComponents();
            
            //Flag used in Update() to "play" car moving animation
            bPlayAnimation = true;

            StartCoroutine(StopAnimationAfterTimerEnds());
            
            //Iterate through all audio cues for the current animation setting and play respective audio after some elapsed time
            if (m_currentAnimationSetting)
            {
                for (int i = 0; i < m_audioSources.Count; i++)
                {
                    //Store coroutine in a list
                    IEnumerator soundCoroutine = PlaySoundAtTime(m_currentAnimationSetting.carAudioSettings[i], m_audioSources[i]);
                    m_audioCueCoroutines.Add(soundCoroutine);
                    
                    //Call sound coroutine 
                    StartCoroutine(soundCoroutine);
                }
            }
        }

        IEnumerator StopAnimationAfterTimerEnds()
        {
            yield return new WaitForSeconds(m_currentAnimationSetting.animationTime);
          
            StopAnimation();
        }

        IEnumerator PlaySoundAtTime(CarAudioSetting audioSetting, AudioSource audioSource)
        {
            yield return new WaitForSeconds(audioSetting.timeToPlayAudio);
            
            //Play sound
            audioSource.clip = audioSetting.audioClipToPlay;
            audioSource.volume = audioSetting.volume;
            audioSource.Play();
            
            Debug.Log("MANIPULATECAR.cs: PlaySoundAtTime was called for sound: " + audioSetting.audioClipToPlay.name);
        }

        public void StopAnimation(bool bResetCarConfig = false)
        {
            bPlayAnimation = false;
            m_elapsedTime = 0f;
          
            //Clear any coroutine in the case animation was stopped prematurely
            StopCoroutine(nameof(StopAnimationAfterTimerEnds));
            
            //Clear all audio playing coroutines in case animation was stopped prematurely
            foreach (IEnumerator coroutine in m_audioCueCoroutines)
            {
                StopCoroutine(coroutine);
            }
            //Empty audio cue coroutine list
            m_audioCueCoroutines.Clear();

            //Remove all audio source components from the game object
            RemoveAudioSourceComponents();
            

            if (bResetCarConfig)
            {
                //Reset position of car
                transform.SetPositionAndRotation(m_startPosition, m_startRotation);
              
            }
          
        }
  
        void Update()
        {
            if (!bPlayAnimation) return;
          
            if (m_currentAnimationSetting && m_elapsedTime < m_currentAnimationSetting.animationTime)
            {
                // Increment the elapsed time
                m_elapsedTime += Time.deltaTime;
      
                // Calculate the normalized time (0 to 1)
                float normalizedTime = (m_elapsedTime / m_currentAnimationSetting.animationTime);
      
                // Apply easing using the AnimationCurve
                float easedTime = easeCurve.Evaluate(normalizedTime);
      
                // Interpolate between the start and final positions
                transform.position = Vector3.LerpUnclamped(m_startPosition, m_finalPosition, easedTime);

            }
        }

        private void SetupAudioSourceComponents()
        {
            //Create n number of audio sources, and add them to a list
            foreach (CarAudioSetting carAudioSetting in m_currentAnimationSetting.carAudioSettings)
            {
                //Create audio source
                AudioSource audioSource = gameObject.AddComponent<AudioSource>();
                audioSource.playOnAwake = false;
                
                //Add audio source to a list
                m_audioSources.Add(audioSource);
            }
        }

        private void RemoveAudioSourceComponents()
        {
            foreach (AudioSource source in m_audioSources)
            {
                source.Stop();
                Destroy(source);
            }
        }
      
    }
}
