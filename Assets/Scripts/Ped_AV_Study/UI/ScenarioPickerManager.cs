using System;
using System.Collections.Generic;
using System.Linq;
using Ped_AV_Study;
using Ped_AV_Study.ScriptableObjectBase;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class ScenarioPickerManager : MonoBehaviour
{

    [Header("Menu UI Elements")]
    public GameObject mainMenuUI;
    public GameObject carBehaviorMenuUI;
    public GameObject stoppingDistMenuUI;
    public GameObject audioMenuUI;
    public GameObject selectAudioMenuUI;
    public GameObject carAnimPlayingUI;
    
    [Header("UI Toggle Group Elements")]
    public ToggleGroup carBehaviorToggleGroup;
    public ToggleGroup stoppingDistanceToggleGroup;
    public ToggleGroup audioToggleGroup;

    [Header("Car Audio Menu Related References")]
    public GameObject audioOptionsPanel;
    public GameObject audioOptionPrefab;
    public List<CarAudioSetting> carAudioSettings;
    public Toggle audioLoopToggle;
    public Toggle dynamicAudioToggle;
    private Dictionary<int, CarAudioSetting> mapAudioUIToAudioSetting = new Dictionary<int, CarAudioSetting>();
    [Header("Miscellaneous References")]
    public ManipulateCar manipulateCarScript;
    
    private CarAnimationSetting m_currentCarAnimationSetting;
    private CarAudioSetting m_currentCarAudioSetting;

    void Start()
    {
        AddAudioClipsToMenu();
    }

    // -- Car Animation Functions -- 
    public void StartCarAnimation()
    {
        HideAllMenus();
        
        manipulateCarScript.SetAnimationSettings(m_currentCarAnimationSetting);
        manipulateCarScript.StartAnimation();
        
        carAnimPlayingUI.SetActive(true);
    }

    public void RestartCarAnimation()
    {
        HideAllMenus();
        
        manipulateCarScript.StopAnimation();
        
        ShowMainMenu();
    }
    
    // -- END --

    // --- Car Behavior Menu Functions ---
    public void SaveCarBehavior()
    {
        Toggle toggle = carBehaviorToggleGroup.ActiveToggles().FirstOrDefault();

        if (toggle == null)
        {
            Debug.LogError("No car behavior toggle selected");
            return;
        }
        
        // Debug.Log("");
        
        if (toggle.gameObject.name == "StopToggle") //The car should stop
        {
            m_currentCarAnimationSetting = Instantiate(manipulateCarScript.NearDistAnimationSetting);
        }
        else // The car should pass
        {
            m_currentCarAnimationSetting = Instantiate(manipulateCarScript.NoStopAnimationSetting);
        }
        
        // Debug.Log("Saved Car Behavior " + currentCarAnimationSetting.name);

        //Add audio settings in-case already selected and has been overwritten
        CheckAndAddAudioSetting();
    }

    public void ReturnFromCarBehaviorMenu()
    {
        //Save car behavior in case it wasn't set
        if(m_currentCarAnimationSetting == null)
            SaveCarBehavior();
        
        ShowMainMenu();
    }
    
    // --- END ---
    
    // --- Audio Menu Functions ---
    
    //Adds audio clip options to the audio menu based on the list of CarAudioSetting objects

    public void UpdateAudioLoopSetting()
    {
        if (m_currentCarAudioSetting == null)
        {
            Debug.LogWarning("No car audio currently selected when setting the audio to loop");
            return;
        }
        
        Debug.Log("Updating audio loop: " + audioLoopToggle.isOn);
        
        m_currentCarAudioSetting.bLoopAudio = audioLoopToggle.isOn;
    }
    
    public void UpdateDynamicAudioSetting()
    {
        if (m_currentCarAudioSetting == null)
        {
            Debug.LogWarning("No car audio currently selected when setting the audio to be 3 dimensional");
            return;
        }
        
        Debug.Log("Updating audio to 3D audio: " + dynamicAudioToggle.isOn);

        m_currentCarAudioSetting.bDynamicAudio = dynamicAudioToggle.isOn;
    }
    private void AddAudioClipsToMenu()
    {
        //Iterate over CarAudioSetting list
        foreach (CarAudioSetting carAudioSetting in carAudioSettings)
        {
            //Create audio prefab and attach it to audio options panel
            GameObject audioOption = Instantiate(audioOptionPrefab, audioOptionsPanel.transform);

            //Map ID of game object to car audio setting
            mapAudioUIToAudioSetting.Add(audioOption.GetInstanceID(), carAudioSetting);
            
            //Update text of UI to reflect audio setting
            audioOption.transform.GetComponentInChildren<TextMeshProUGUI>().text = carAudioSetting.name;

            //Assign toggle component to audio toggle group
            audioOption.GetComponent<Toggle>().group = audioToggleGroup;
        }
    }
    public void SaveAudioClipToPlay()
    {
        Toggle toggle = audioToggleGroup.ActiveToggles().FirstOrDefault();

        if (toggle == null)
        {
            Debug.LogError("No audio clip toggle selected");
            return;
        }
        
        //Clear any audio setting on current car animation 
        m_currentCarAnimationSetting.carAudioSettings.Clear();
        
        //Get audio setting corresponding to gameobject
        CarAudioSetting carAudioSetting = mapAudioUIToAudioSetting[toggle.gameObject.GetInstanceID()];

        if (carAudioSetting == null)
        {
            Debug.LogWarning("No corresponding audio setting was found for audio option");
            return;
        }
        
        //Add audio setting to current animation setting
        m_currentCarAnimationSetting.carAudioSettings.Add(carAudioSetting);
        
        //Store current car audio setting 
        m_currentCarAudioSetting = carAudioSetting;
        
        Debug.Log("Added Car audio to current animation setting: " + carAudioSetting.name);
    }

    public void ReturnFromSelectAudioMenu()
    {
        HideAllMenus();
        
        ShowAudioMenu();
    }
    
    // --- END ---
    
    // --- Stopping Distance Menu Functions ---
    
    public void SaveStoppingDistance()
    {
        Toggle toggle = stoppingDistanceToggleGroup.ActiveToggles().FirstOrDefault();

        if (toggle == null)
        {
            Debug.LogError("No car behavior toggle selected");
            return;
        }
        
        if (toggle.gameObject.name == "NearDistToggle") //The car should stop close to the ped
        {
            m_currentCarAnimationSetting = Instantiate(manipulateCarScript.NearDistAnimationSetting);
        }
        else if(toggle.gameObject.name == "MediumDistToggle") // The car should stop at a medium distance
        {
            m_currentCarAnimationSetting = Instantiate(manipulateCarScript.MediumDistAnimationSetting);
        }
        else //The car should stop afar
        {
            m_currentCarAnimationSetting = Instantiate(manipulateCarScript.FarDistAnimationSetting);
        }
        
        // Debug.Log("Saved Car Stopping Distance " + currentCarAnimationSetting.name);

        //Add audio settings in-case already selected and has been overwritten
        CheckAndAddAudioSetting();
    }

    public void ReturnFromStoppingDistMenu()
    {
        //Save car behavior in case it wasn't set
        if(m_currentCarAnimationSetting == null)
            SaveStoppingDistance();
        
        ShowMainMenu();
    }

    
    // --- END ---
    
    // -- SHOW Menu Functions --
    public void ShowCarBehaviorMenu()
    {
        HideAllMenus();
        
        carBehaviorMenuUI.SetActive(true);
    }
    
    public void ShowStoppingDistMenu()
    {
        HideAllMenus();
        
        stoppingDistMenuUI.SetActive(true);
    }
    
    public void ShowAudioMenu()
    {
        HideAllMenus();
        
        audioMenuUI.SetActive(true);
    }

    public void ShowSelectAudioMenu()
    {
        HideAllMenus();
        
        selectAudioMenuUI.SetActive(true);
    }

    public void ShowMainMenu()
    {
        HideAllMenus();
        
        mainMenuUI.SetActive(true);
    }

    // -- HIDE MENUS Function --
    private void HideCarBehaviorMenu()
    {
        carBehaviorMenuUI.SetActive(false);
    }
    private void HideStoppingDistMenu()
    {
        stoppingDistMenuUI.SetActive(false);
    }
    
    private void HideAudioMenu()
    {
        audioMenuUI.SetActive(false);
    }
    
    private void HideMainMenu()
    {
        mainMenuUI.SetActive(false);
    }

    private void HideAllMenus()
    {
        HideMainMenu();
        HideAudioMenu();
        HideStoppingDistMenu();
        HideCarBehaviorMenu();
        carAnimPlayingUI.SetActive(false);
        selectAudioMenuUI.SetActive(false);
    }
    
    // -- END --
    
    // -- HELPER FUNCTIONS

    // This checks if an audio setting is selected, if so, add it to the car animation setting 
    //Usually used when audio setting is already selected, and user changes the entire car anim setting 
    private void CheckAndAddAudioSetting()
    {

        if (m_currentCarAudioSetting == null)
            return;
        
        //Clear any previous audio settings 
        m_currentCarAnimationSetting.carAudioSettings.Clear();
        
        //Add selected audio setting
        m_currentCarAnimationSetting.carAudioSettings.Add(m_currentCarAudioSetting);
    }
}
