import React, { useState } from "react";
import { debugData } from "../utils/debugData";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { setConfig } from "../slices/configSlice";
import { setLocale } from "../slices/localeSlice";
import { useDispatch } from "react-redux";
import setTheme from "../utils/setTheme";

// This will set the NUI to visible if we are
// developing in browser
debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

const App: React.FC = () => {
  const dispatch = useDispatch();

  useNuiEvent("setLocale", (locale) => dispatch(setLocale(locale)));
  useNuiEvent("setConfig", (config: any) => {
    dispatch(setConfig(config));
    console.log(24, config.Theme)
    setTheme(config.Theme)
  });

  return (
    <div className="w-full h-screen">
      
    </div>
  );
};

export default App;
