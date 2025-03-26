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
    
    public ToggleGroup carBehaviorToggleGroup;
    public ToggleGroup stoppingDistanceToggleGroup;

    public ManipulateCar manipulateCarScript;
    private CarAnimationSetting currentCarAnimationSetting;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // --- Car Behavior Menu Functions ---
    public void SaveCarBehavior()
    {
        Toggle toggle = carBehaviorToggleGroup.ActiveToggles().FirstOrDefault();

        if (toggle == null)
        {
            Debug.LogError("No car behavior toggle selected");
            return;
        }
        
        if (toggle.gameObject.name == "StopToggle") //The car should stop
        {
            currentCarAnimationSetting = manipulateCarScript.NearDistAnimationSetting;
        }
        else // The car should pass
        {
            currentCarAnimationSetting = manipulateCarScript.NoStopAnimationSetting;
        }
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
    
    
    
    // --- END ---
    
    // --- Stopping Distance Menu Functions ---
    
    public void SaveStoppingDistance()
    {
        Toggle toggle = carBehaviorToggleGroup.ActiveToggles().FirstOrDefault();

        if (toggle == null)
        {
            Debug.LogError("No car behavior toggle selected");
            return;
        }
        
        if (toggle.gameObject.name == "NearDistToggle") //The car should stop close to the ped
        {
            currentCarAnimationSetting = manipulateCarScript.NearDistAnimationSetting;
        }
        else if(toggle.gameObject.name == "MediumDistToggle") // The car should stop at a medium distance
        {
            currentCarAnimationSetting = manipulateCarScript.MediumDistAnimationSetting;
        }
        else //The car should stop afar
        {
            currentCarAnimationSetting = manipulateCarScript.FarDistAnimationSetting;
        }
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
    }
}
