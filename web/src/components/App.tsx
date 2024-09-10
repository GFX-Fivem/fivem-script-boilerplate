import React, { useState } from "react";
import { debugData } from "../utils/debugData";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { setConfig } from "../slices/configSlice";
import { setLocale } from "../slices/localeSlice";
import { useDispatch } from "react-redux";

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
  useNuiEvent("setConfig", (config) => dispatch(setConfig(config)));

  return (
    <div>
      
    </div>
  );
};

export default App;
