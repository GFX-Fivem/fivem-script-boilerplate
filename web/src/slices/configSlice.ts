import { createSlice } from '@reduxjs/toolkit';

export interface ConfigState {
    config: {
        [key: string]: string | number | Object
    };
}

const initialState: ConfigState = {
    config: {}
};

const configSlice = createSlice({
    name: 'locale',
    initialState,
    reducers: {
        setConfig: (state, action) => {
            state.locale = action.payload
        }
    },
});

export const { setConfig } = configSlice.actions;
export default configSlice.reducer;