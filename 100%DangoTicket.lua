sdk.hook(sdk.find_type_definition("snow.data.DangoData"):get_method("get_SkillActiveRate"),
    function(args)
        isSelectedDangoTicket = sdk.get_managed_singleton("snow.data.FacilityDataManager"):get_field("_Kitchen"):get_field("_MealFunc"):call("getMealTicketFlag");
        if isSelectedDangoTicket then
            selectedDango = sdk.to_managed_object(args[2]);
            defaultRate = selectedDango:get_field("_Param"):get_field("_SkillActiveRate")
            selectedDango:get_field("_Param"):set_field("_SkillActiveRate", defaultRate + 100);
        end
    end,
    function(retval)
        if isSelectedDangoTicket then
            selectedDango:get_field("_Param"):set_field("_SkillActiveRate", defaultRate);
        end
        return retval;
    end
);
