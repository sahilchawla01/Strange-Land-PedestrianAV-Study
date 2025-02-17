using System.Collections;
using System.Collections.Generic;
using Ped_AV_Study.ScriptableObjectBase;
using UnityEngine;

namespace Ped_AV_Study
{
    [RequireComponent(typeof(AudioSource))]
    public class ManipulateCar : MonoBehaviour
    {
        public AnimationCurve easeCurve = AnimationCurve.EaseInOut(0, 0, 1, 1); // Easing curve
        public CarAnimationSetting initAnimationSetting;
        public List<CarAnimationSetting> carAnimations = new List<CarAnimationSetting>();
      
        // -- COMPONENTS --
        private AudioSource m_audioSource;   
        private CarAnimationSetting m_currentAnimationSetting;
      
      
        private Vector3 m_finalPosition;
        private Vector3 m_startPosition;
        private Quaternion m_startRotation;
        private float m_elapsedTime = 0f;
        
        private bool bPlayAnimation = false;
        void Start()
        {
            //Store components
            m_audioSource = GetComponent<AudioSource>();
          
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
            bPlayAnimation = true;

            StartCoroutine(StopAnimationAfterTimerEnds());
        }

        IEnumerator StopAnimationAfterTimerEnds()
        {
            yield return new WaitForSeconds(m_currentAnimationSetting.animationTime);
          
            StopAnimation();
        }

        public void StopAnimation(bool bResetCarConfig = false)
        {
            bPlayAnimation = false;
          
            //Clear any coroutine in the case animation was stopped prematurely
            StopCoroutine(nameof(StopAnimationAfterTimerEnds));

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
      
    }
}
