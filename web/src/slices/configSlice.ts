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
    name: 'config',
    initialState,
    reducers: {
        setConfig: (state, action) => {
            state.config = action.payload
        }
    },
});

export const { setConfig } = configSlice.actions;
export default configSlice.reducer;
