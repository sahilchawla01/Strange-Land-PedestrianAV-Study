using UnityEngine;

namespace Ped_AV_Study
{
    public class AnimateWheels : MonoBehaviour
    {
        public float wheelRadius = 0.3f;
        private GameObject[] wheels;
        private readonly float TwoPI = 6.28318530718f;
        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
        }

        public void SetWheelGameObjects(in GameObject[] wheelsList, in Vector3 axisToRotateAround)
        {
            wheels = wheelsList;
        }

        public void CalculateAndSetWheelRotations(in float carSpeed)
        {
            //Calculate how much rotation to add
            
            //Iterate through all wheels and add rotation
            // Quaternion.rota
        }
    }
}
