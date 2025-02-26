using UnityEngine;

namespace Ped_AV_Study
{
    public class AnimateWheels : MonoBehaviour
    {
        public float wheelRadius = 0.3f;
        public GameObject[] wheels;

        public void CalculateAndSetWheelRotations(in float carSpeed)
        {
            //Calculate how much rotation speed
            float angularVelocity = carSpeed / wheelRadius;
            // Convert to degrees per frame
            float rotationSpeed = angularVelocity * Mathf.Rad2Deg; 
            
            //Iterate through all wheels and add rotation
            foreach (GameObject wheel in wheels)
            {
                wheel.transform.Rotate(Vector3.up, -rotationSpeed * Time.deltaTime);
            }
        }
    }
}
