using System.Linq;
using Ped_AV_Study;
using Ped_AV_Study.ScriptableObjectBase;
using UnityEngine;
using UnityEngine.UI;

public class ScenarioPickerManager : MonoBehaviour
{

    public GameObject MainMenuUI;
    public GameObject CarBehaviorMenuUI;
    public GameObject StoppingDistMenuUI;
    public GameObject AudioMenuUI;
    public GameObject SelectAudioMenuUI;
    public GameObject CarAnimPlayingUI;
    
    public ToggleGroup carBehaviorToggleGroup;
    public ToggleGroup stoppingDistanceToggleGroup;

    public ManipulateCar manipulateCarScript;
    private CarAnimationSetting currentCarAnimationSetting;

    // -- Car Animation Functions -- 
    public void StartCarAnimation()
    {
        HideAllMenus();
        
        manipulateCarScript.SetAnimationSettings(currentCarAnimationSetting);
        manipulateCarScript.StartAnimation();
        
        CarAnimPlayingUI.SetActive(true);
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
            currentCarAnimationSetting = Instantiate(manipulateCarScript.NearDistAnimationSetting);
        }
        else // The car should pass
        {
            currentCarAnimationSetting = Instantiate(manipulateCarScript.NoStopAnimationSetting);
        }
        
        // Debug.Log("Saved Car Behavior " + currentCarAnimationSetting.name);
    }

    public void ReturnFromCarBehaviorMenu()
    {
        //Save car behavior in case it wasn't set
        if(currentCarAnimationSetting == null)
            SaveCarBehavior();
        
        ShowMainMenu();
    }
    
    
    // --- END ---
    
    // --- Audio Menu Functions ---

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
            currentCarAnimationSetting = Instantiate(manipulateCarScript.NearDistAnimationSetting);
        }
        else if(toggle.gameObject.name == "MediumDistToggle") // The car should stop at a medium distance
        {
            currentCarAnimationSetting = Instantiate(manipulateCarScript.MediumDistAnimationSetting);
        }
        else //The car should stop afar
        {
            currentCarAnimationSetting = Instantiate(manipulateCarScript.FarDistAnimationSetting);
        }
        
        // Debug.Log("Saved Car Stopping Distance " + currentCarAnimationSetting.name);

    }

    public void ReturnFromStoppingDistMenu()
    {
        //Save car behavior in case it wasn't set
        if(currentCarAnimationSetting == null)
            SaveStoppingDistance();
        
        ShowMainMenu();
    }

    
    // --- END ---
    
    // -- SHOW Menu Functions --
    public void ShowCarBehaviorMenu()
    {
        HideAllMenus();
        
        CarBehaviorMenuUI.SetActive(true);
    }
    
    public void ShowStoppingDistMenu()
    {
        HideAllMenus();
        
        StoppingDistMenuUI.SetActive(true);
    }
    
    public void ShowAudioMenu()
    {
        HideAllMenus();
        
        AudioMenuUI.SetActive(true);
    }

    public void ShowSelectAudioMenu()
    {
        HideAllMenus();
        
        SelectAudioMenuUI.SetActive(true);
    }

    public void ShowMainMenu()
    {
        HideAllMenus();
        
        MainMenuUI.SetActive(true);
    }

    // -- HIDE MENUS Function --
    private void HideCarBehaviorMenu()
    {
        CarBehaviorMenuUI.SetActive(false);
    }
    private void HideStoppingDistMenu()
    {
        StoppingDistMenuUI.SetActive(false);
    }
    
    private void HideAudioMenu()
    {
        AudioMenuUI.SetActive(false);
    }
    
    private void HideMainMenu()
    {
        MainMenuUI.SetActive(false);
    }

    private void HideAllMenus()
    {
        HideMainMenu();
        HideAudioMenu();
        HideStoppingDistMenu();
        HideCarBehaviorMenu();
        CarAnimPlayingUI.SetActive(false);
        SelectAudioMenuUI.SetActive(false);
    }
}
