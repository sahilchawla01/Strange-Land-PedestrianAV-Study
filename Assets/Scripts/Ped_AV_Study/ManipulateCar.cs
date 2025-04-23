using System.Collections;
using System.Collections.Generic;
using Ped_AV_Study;
using Ped_AV_Study.ScriptableObjectBase;
using UnityEngine;

namespace Ped_AV_Study
{
    [RequireComponent(typeof(AnimateWheels))]
    public class ManipulateCar : MonoBehaviour
    {
        public CarAnimationSetting initAnimationSetting;
        public List<CarAnimationSetting> carAnimations = new List<CarAnimationSetting>();

        public CarAnimationSetting NearDistAnimationSetting;
        public CarAnimationSetting MediumDistAnimationSetting;
        public CarAnimationSetting FarDistAnimationSetting;
        public CarAnimationSetting NoStopAnimationSetting;
        
        // -- COMPONENTS --
        private List<AudioSource> m_audioSources = new List<AudioSource>();
        private CarAnimationSetting m_currentAnimationSetting;
        private AnimateWheels m_animateWheelsScript;
      
        // -- MISCELLANEOUS -- 
        private Vector3 m_animFinalPosition;
        private Vector3 m_animStartPosition;
        private Vector3 m_animPositionLastFrame;
        private Quaternion m_animStartRotation;
        private float m_elapsedTime = 0f;
        
        private bool bPlayAnimation = false;

        //This position refers the reference point where the car is placed in the scene initially.
        private Vector3 m_initCarPosition;
        private Quaternion m_initCarRotation;
        
        // -- COROUTINES -
        List<IEnumerator> m_audioCueCoroutines = new List<IEnumerator>();
        void Start()
        {
            m_initCarPosition = transform.position;
            m_initCarRotation = transform.rotation;
            
            //Store scripts
            m_animateWheelsScript = GetComponent<AnimateWheels>();
          
            //Set animation setting before playing the car animation
            // SetAnimationSettings(initAnimationSetting);
            
            // StartAnimation();
        }

        public void SetAnimationSettings(CarAnimationSetting animationSetting)
        {
            if (animationSetting == null)
            {
                animationSetting = initAnimationSetting;
                Debug.LogWarning("No animation setting was provided to set animation setting, using default anim setting");
            }
            
            //Store curr animation setting
            m_currentAnimationSetting = animationSetting;
            
            ResetCarStateToDefault();
                
            // Store the final position and rotation and bring final pos back by specified amount
            m_animFinalPosition = transform.position - transform.forward * m_currentAnimationSetting.earlyStoppingDistance;
            m_animStartRotation = transform.rotation;
          
            // Calculate the start position by moving in the opposite direction of the forward vector
            m_animStartPosition = m_animFinalPosition - transform.forward * m_currentAnimationSetting.totalAnimationDistance;
            m_animPositionLastFrame = m_animStartPosition;
            
        }

      
        public void StartAnimation()
        {
            if (!m_currentAnimationSetting)
            {
                Debug.LogError("MANIPULATECAR.cs: No animation setting when StartAnimation was called");
                return;
            }
            
            Debug.Log("MANIPULATECAR.cs: Starting car animation");

            ResetCarStateToAnimationStart();
            
            //According to the number of audio cues, create audio source components
            SetupAudioSourceComponents();
            
            //Flag used in Update() to "play" car moving animation
            bPlayAnimation = true;
            
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
        
        //Resets the state of the car to when there is no animation (for example: Car is placed at its scene start location)
        private void ResetCarStateToDefault()
        {
            //Reset car position to no animation position / reference position
            transform.SetPositionAndRotation(m_initCarPosition, m_initCarRotation);
        }
        
        //Resets the state of the car required when the animation just begins( for example: Car is placed at animation start location)
        private void ResetCarStateToAnimationStart()
        {
            // Set up the animation initial transform for the car
            transform.SetPositionAndRotation(m_animStartPosition, m_animStartRotation);
        }
        
        IEnumerator PlaySoundAtTime(CarAudioSetting audioSetting, AudioSource audioSource)
        {
            yield return new WaitForSeconds(audioSetting.timeToPlayAudio);
            
            //Loop audio if required to 
            audioSource.loop = audioSetting.bLoopAudio;
            
            //Play sound
            audioSource.clip = audioSetting.audioClipToPlay;
            audioSource.volume = audioSetting.volume;
            audioSource.Play();
            
            
            Debug.Log("MANIPULATECAR.cs: PlaySoundAtTime was called for sound: " + audioSetting.audioClipToPlay.name);
        }

        public void StopAnimation(bool bResetCarState = false)
        {
            if (bPlayAnimation == false)
            {
                Debug.LogWarning("MANIPULATECAR.CS: Animation was not playing when StopAnimation was called. Returning.");
                return;
            }
            
            Debug.Log("MANIPULATECAR.cs: Stopping animation, reset car state: " + bResetCarState);

            bPlayAnimation = false;
            m_elapsedTime = 0f;
            
            //Clear all audio playing coroutines in case animation was stopped prematurely
            foreach (IEnumerator coroutine in m_audioCueCoroutines)
            {
                StopCoroutine(coroutine);
            }
            //Empty audio cue coroutine list
            m_audioCueCoroutines.Clear();

            //Remove all audio source components from the game object
            RemoveAudioSourceComponents();
            
            //Reset car state to state when no animation plays
            if (bResetCarState)
                ResetCarStateToDefault();
          
        }
  
        void Update()
        {
            // if (Input.GetKeyDown(KeyCode.R))
            // {
            //     StopAnimation();
            // }
            //
            // if (Input.GetKeyDown(KeyCode.Space))
            // {
            //     StopAnimation(true);
            // }
            //
            // if (Input.GetKeyDown(KeyCode.P))
            // {
            //     StartAnimation();
            // }
            //
            //If no animation is playing, or there is no assigned animation setting, return
            if (!bPlayAnimation || !m_currentAnimationSetting) return;
            
            //When animation is running, calculate and set state of the car including position, wheel rotation, etc.
            if (m_elapsedTime < m_currentAnimationSetting.animationTime)
            {
                // Increment the elapsed time
                m_elapsedTime += Time.deltaTime;
      
                // Calculate the normalized time (0 to 1)
                float normalizedTime = (m_elapsedTime / m_currentAnimationSetting.animationTime);
      
                // Apply easing using the AnimationCurve
                float easedTime = m_currentAnimationSetting.easeCurve.Evaluate(normalizedTime);
      
                // Interpolate between the start and final positions
                transform.position = Vector3.LerpUnclamped(m_animStartPosition, m_animFinalPosition, easedTime);
                
                //Get distance travelled in 1 frame
                float distanceTravelled = Vector3.Distance(transform.position, m_animPositionLastFrame);
                float carSpeed = distanceTravelled / Time.deltaTime;
                
                //Animate the wheels according to current speed
                m_animateWheelsScript.CalculateAndSetWheelRotations(carSpeed);
                
                //Update last frame position
                m_animPositionLastFrame = transform.position;
            }
            else
            {
                Debug.Log("MANIPULATECAR.cs: Animation time has completed. Stopping animation.");
                StopAnimation();
            }
        }

        private void SetupAudioSourceComponents()
        {
            // Debug.Log("MANIPULATECAR.cs: Adding audio source components ");

            //Create n number of audio sources, and add them to a list
            foreach (CarAudioSetting carAudioSetting in m_currentAnimationSetting.carAudioSettings)
            {
                //Create audio source
                AudioSource audioSource = gameObject.AddComponent<AudioSource>();
                audioSource.playOnAwake = false;
                //Set 3D audio
                if (carAudioSetting.bDynamicAudio)
                {
                    audioSource.spatialize = true;
                    audioSource.spatialBlend = 1.0f;
                }
                else //2D audio
                {
                    audioSource.spatialize = false;
                    audioSource.spatialBlend = 0.0f;
                }
                
                //Add audio source to a list
                m_audioSources.Add(audioSource);
            }
        }

        private void RemoveAudioSourceComponents()
        {
            // Debug.Log("MANIPULATECAR.cs: Removing audio source components ");

            if (m_audioSources.Count == 0)
            {
                Debug.Log("MANIPULATECAR.cs: Audio source components are empty when trying to remove them. Returning");
                return;
            }
            
            foreach (AudioSource source in m_audioSources)
            {
                source.Stop();
                Destroy(source);
            }
            
            m_audioSources.Clear();
        }
      
    }
}
